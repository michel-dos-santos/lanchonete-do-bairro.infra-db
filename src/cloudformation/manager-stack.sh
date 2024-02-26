PS3="O que deseja fazer com a sua stack: "

items=("Criar Stack" "Excluir Stack", "Criar VPC", "Excluir VPC", "Criar DB", "Excluir DB")

echo ">>>>> Obtendo definição dos atributos interno do script <<<<<"
AWS_REGION=us-east-1
VPC_STACK_NAME=lanchonete-do-bairro-vpc
DB_STACK_NAME=lanchonete-do-bairro-postgresql-instance1
AWS_ARN_ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
wait

function createStacks {
  createVPC
  createDB
}

function deleteStacks {
  deleteStack $DB_STACK_NAME
  deleteStack $VPC_STACK_NAME
}


function createVPC {
  aws cloudformation create-stack \
    --region $AWS_REGION \
    --stack-name $VPC_STACK_NAME \
    --template-body file://vpc-stack.yaml

  verifyStatus $VPC_STACK_NAME
  wait
}

function createDB {
  aws cloudformation create-stack \
    --region $AWS_REGION \
    --stack-name $DB_STACK_NAME \
    --template-body file://db-stack.yaml

  verifyStatus $DB_STACK_NAME
  wait
}

function deleteStack {
  aws cloudformation delete-stack \
        --region $AWS_REGION \
        --stack-name $1

  verifyStatus $1
  wait
}

function verifyStatus {
  started_date=$(date '+%H:%M:%S')
  start=`date +%s`
  while true; do
    if [[ $(aws cloudformation describe-stacks --region $AWS_REGION --stack-name $1 --query "Stacks[*].StackStatus" --output text) == CREATE_IN_PROGRESS ]]
    then
      echo -e "Stack status : CREATE IN PROGRESS"
      sleep 10
    elif [[ $(aws cloudformation describe-stacks --region $AWS_REGION --stack-name $1 --query "Stacks[*].StackStatus" --output text) == DELETE_IN_PROGRESS ]]
    then
      echo -e "Stack status : DELETE IN PROGRESS"
      sleep 10
    elif [[ $(aws cloudformation describe-stacks --region $AWS_REGION --stack-name $1 --query "Stacks[*].StackStatus" --output text) == CREATE_COMPLETE ]]
    then
      echo -e "Stack status : SUCCESSFULLY CREATED"
      end=`date +%s`
      runtime=$((end-start))
      finished_date=$(date '+%H:%M:%S')
      echo "started at :" $started_date
      echo "finished at :" $finished_date
      hours=$((runtime / 3600)); minutes=$(( (runtime % 3600) / 60 )); seconds=$(( (runtime % 3600) % 60 )); echo "Total time : $hours h $minutes min $seconds sec"
      break
    else
      echo -e "Stack status : $(aws cloudformation describe-stacks --region $AWS_REGION --stack-name $1 --query "Stacks[*].StackStatus" --output text) n"
      break
    fi
  done
}

select item in "${items[@]}" Quit
do
    case $REPLY in
        1) createStacks;;
        2) deleteStacks;;
        3) createVPC;;
        4) deleteStack $VPC_STACK_NAME;;
        5) createDB;;
        6) deleteStack $DB_STACK_NAME;;
        $((${#items[@]}+1))) echo "We're done!"; break;;
        *) echo "Ooops - unknown choice $REPLY";;
    esac
done