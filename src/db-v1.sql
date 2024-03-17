-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE public.sequence_number_number_seq;

CREATE SEQUENCE public.sequence_number_number_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.sequence_number definition

-- Drop table

-- DROP TABLE public.sequence_number;

CREATE TABLE public.sequence_number (
	"number" serial4 NOT NULL,
	CONSTRAINT sequence_number_pkey PRIMARY KEY (number)
);


-- public.tb_billing_form definition

-- Drop table

-- DROP TABLE public.tb_billing_form;

CREATE TABLE public.tb_billing_form (
	id uuid NOT NULL,
	billing_form_type varchar(255) NULL,
	created_at timestamp(6) NOT NULL,
	updated_at timestamp(6) NULL,
	CONSTRAINT tb_billing_form_billing_form_type_check CHECK (((billing_form_type)::text = ANY ((ARRAY['QRCODE_MERCADO_PAGO'::character varying, 'PIX_ITAU'::character varying])::text[]))),
	CONSTRAINT tb_billing_form_pkey PRIMARY KEY (id)
);


-- public.tb_category definition

-- Drop table

-- DROP TABLE public.tb_category;

CREATE TABLE public.tb_category (
	id uuid NOT NULL,
	created_at timestamp(6) NOT NULL,
	description varchar(255) NOT NULL,
	"name" varchar(50) NOT NULL,
	updated_at timestamp(6) NULL,
	CONSTRAINT tb_category_pkey PRIMARY KEY (id),
	CONSTRAINT uk_4gpl7afmaxiecnv7fv7unn2mp UNIQUE (name)
);


-- public.tb_client definition

-- Drop table

-- DROP TABLE public.tb_client;

CREATE TABLE public.tb_client (
	id uuid NOT NULL,
	cpf varchar(14) NOT NULL,
	created_at timestamp(6) NOT NULL,
	email varchar(50) NOT NULL,
	"name" varchar(50) NOT NULL,
	updated_at timestamp(6) NULL,
	CONSTRAINT tb_client_pkey PRIMARY KEY (id)
);


-- public.tb_billing definition

-- Drop table

-- DROP TABLE public.tb_billing;

CREATE TABLE public.tb_billing (
	id uuid NOT NULL,
	created_at timestamp(6) NOT NULL,
	status varchar(255) NULL,
	total_price numeric(38, 2) NULL,
	updated_at timestamp(6) NULL,
	fk_billing_form_id uuid NULL,
	CONSTRAINT tb_billing_pkey PRIMARY KEY (id),
	CONSTRAINT tb_billing_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING_PAYMENT'::character varying, 'PAID'::character varying])::text[]))),
	CONSTRAINT uk_pgfpw45bu9dojgcx7pmy8gi81 UNIQUE (fk_billing_form_id),
	CONSTRAINT fk2x1ek1kqmktq1okdn7hvxn8eu FOREIGN KEY (fk_billing_form_id) REFERENCES public.tb_billing_form(id)
);


-- public.tb_order definition

-- Drop table

-- DROP TABLE public.tb_order;

CREATE TABLE public.tb_order (
	id uuid NOT NULL,
	created_at timestamp(6) NOT NULL,
	"number" int4 NULL,
	status varchar(255) NULL,
	updated_at timestamp(6) NULL,
	fk_billing_id uuid NULL,
	fk_client_id uuid NULL,
	CONSTRAINT tb_order_pkey PRIMARY KEY (id),
	CONSTRAINT tb_order_status_check CHECK (((status)::text = ANY ((ARRAY['RECEIVED'::character varying, 'IN_BILLING'::character varying, 'IN_PREPARATION'::character varying, 'READY'::character varying, 'FINISHED'::character varying])::text[]))),
	CONSTRAINT uk_r0kf4ko3r9wphcgenhrd0ri6y UNIQUE (fk_billing_id),
	CONSTRAINT fke7v53u7xc3q9w43sx7mk059ts FOREIGN KEY (fk_client_id) REFERENCES public.tb_client(id),
	CONSTRAINT fkl73jvpun1iybrt61mty8jac3n FOREIGN KEY (fk_billing_id) REFERENCES public.tb_billing(id)
);


-- public.tb_product definition

-- Drop table

-- DROP TABLE public.tb_product;

CREATE TABLE public.tb_product (
	id uuid NOT NULL,
	created_at timestamp(6) NOT NULL,
	description varchar(255) NOT NULL,
	image varchar(1024) NOT NULL,
	"name" varchar(50) NOT NULL,
	status varchar(255) NULL,
	unit_price numeric(38, 2) NULL,
	updated_at timestamp(6) NULL,
	fk_category_id uuid NULL,
	CONSTRAINT tb_product_pkey PRIMARY KEY (id),
	CONSTRAINT tb_product_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'INACTIVE'::character varying])::text[]))),
	CONSTRAINT fke5cj015w6dsx2pcefm0uukhfj FOREIGN KEY (fk_category_id) REFERENCES public.tb_category(id)
);


-- public.tb_order_item definition

-- Drop table

-- DROP TABLE public.tb_order_item;

CREATE TABLE public.tb_order_item (
	id uuid NOT NULL,
	created_at timestamp(6) NOT NULL,
	observation varchar(255) NOT NULL,
	quantity int4 NOT NULL,
	updated_at timestamp(6) NULL,
	fk_order_id uuid NULL,
	fk_product_id uuid NULL,
	CONSTRAINT tb_order_item_pkey PRIMARY KEY (id),
	CONSTRAINT fkd4dx4od809dmof6irvyl36yoy FOREIGN KEY (fk_product_id) REFERENCES public.tb_product(id),
	CONSTRAINT fkl3lfuo2v0ig2e25gvfsiqwcum FOREIGN KEY (fk_order_id) REFERENCES public.tb_order(id)
);