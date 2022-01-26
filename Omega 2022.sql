

use master
go 

------------------------------- Crear Base de datos

IF NOT EXISTS (SELECT * FROM sysdatabases Where (name = 'Omega_2022'))
	create database Omega_2022;
else
	drop database Omega_2022;
	create database Omega_2022;

print 'La base de datos Omega_2022 ha sido creada'

go

use Omega_2022

--------------------------------------------------------- Crear Tablas

create table tipo_cliente(
	Codigo_Tipo_Cliente tinyint	primary key,
	Descripcion_Tipo_Cliente varchar(50) not null
)

create table cliente(
	CodCliente int primary key,
	Nombre_Cliente varchar(100) not null,
	Codigo_Tipo_Cliente tinyint not null,
	Codigo_Empresa tinyint not null,
	Tipo_Naturaleza char(3) not null,
	Fecha_Ingreso date not null,
	Codigo_Zona tinyint null,
	Descripcion_Zona text null,
	Codigo_Moneda_Credito varchar(10) null,
	Importe_Limite_Credito decimal(9,4) not null)

create table ubigeo(
	IDUbigeo int primary key,
	Descripcion_Ubicacion_Geografica varchar(50) not null
)

create table tienda(
	IDTienda int primary key,
	Descripcion_Tienda  varchar(50) not null,
	Descripcion_Tienda_Larga text null,
	CO_UNID tinyint not null,
	Codigo_Empresa tinyint not null,
	Descripcion_Direccion text not null,
	CodigoUbigeo int not null,
	Codigo_Pais smallint not null,
	Numero_Telefono1 varchar(20) not null,
	Numero_Telefono2 varchar(20) null,
	Numero_Fax varchar(20) null
)

create table vendedor(
	IDVendedor smallint primary key,
	Nombre_Vendedor varchar(100) not null,
	Codigo_Tipo_Vendedor tinyint not null,
	Codigo_Tienda_Actual tinyint not null,
	Codigo_Empresa tinyint not null
)

create table tipo_producto(
	Codigo_Tipo_Producto tinyint primary key,
	Descripcion_TipoProducto varchar(50) not null
)

create table rubro_producto(
	IDRubro tinyint primary key,
	Descripcion_Rubro_Producto varchar(50) not null,
	Codigo_Tipo tinyint not null
)

create table familia_producto(
	CodigoFamilia smallint primary key,
	FamiliaProducto varchar(50) not null,
	CodigoRubro tinyint not null
)

create table producto(
	IDProducto int primary key,
	Descripcion_Articulo text not null,
	Descripcion_Articulo_Largo text null,
	Codigo_Tipo smallint not null,
	Val_MonedaNacional decimal(9,4) not null,
	Val_MonedaExtranjera decimal(9,4) not null,
	Codigo_Marca int null,
	Descripcion_Marca varchar(50) not null,
	Tipo_Presentacion varchar(50) null,
	Descripcion_Tipo_Presentacion varchar(50) not null,
	Codigo_Empresa int null,
	Codigo_UnidadMedida char(3) not null,
	Descripcion_UnidadMedida varchar(50) not null
)

create table ventacabecera(
	Cod_Venta int primary key,
	Numero_Documento char(15) not null,
	Tipo_Documento char(3) not null,
	Correlativo tinyint not null,
	Codigo_Unidad tinyint not null,
	Codigo_Empresa tinyint not null,
	Codigo_Tipo_Documento char(3) not null,
	Codigo_Unidad_Venta tinyint null,
	CodigoVendedor smallint not null,
	Codigo_Cliente int not null,
	Codigo_Tipo_Facturacion char(3) not null,
	Codigo_Almacen smallint not null,
	Codigo_Ubigeo int not null,
	Codigo_Condicion_Pago smallint not null,
	Codigo_Tienda int not null,
	Numero_Signo smallint not null,
	Fecha_Documento date not null,
	Venta_MonNacional decimal(9,4) not null,
	Venta_MonExtranjera decimal(9,4) not null
)

create table ventadetalle(
	IDVenta int not null,
	CodigoProducto int not null,
	Cantidad smallint not null,
	Venta_MonNacional decimal(9,4) not null,
	Venta_MonExtranjera decimal(9,4) not null,
	Descuento_MonNacional decimal(9,4) not null,
	Descuento_MonExtranjera decimal(9,4) not null,
	Impuesto_MonNacional decimal(9,4) not null,
	Impuesto_MonExtranjera decimal(9,4) not null,
	Costo_MonNacional decimal(9,4) not null,
	Costo_MonExtranjera decimal(9,4) not null,
	Codigo_UnidadMedida char(3) not null,
	Codigo_UnidadMedida_Venta varchar(10) null
)


---------------------------------------------------------- Crear Constraints

------------------------------- Foreign key 

--- tabla cliente
alter table cliente 
add constraint fk_tipo_cliente 
foreign key (Codigo_Tipo_Cliente) references tipo_cliente(Codigo_Tipo_Cliente);

--- tabla tienda
alter table tienda
add constraint fk_codigo_ubigeo
foreign key (CodigoUbigeo) references Ubigeo(IDUbigeo);

--- tabla Rubro Producto
alter table rubro_producto
add constraint fk_codigo_tipo
foreign key (Codigo_Tipo) references tipo_producto(Codigo_Tipo_Producto);

--- tabla familia producto
alter table familia_producto
add constraint fk_codigo_rubro
foreign key (CodigoRubro) references rubro_producto(IDRubro);

--- tabla producto
alter table producto
add constraint fk_codigo_tipo_producto
foreign key (Codigo_Tipo) references familia_producto(CodigoFamilia);

--- tabla ventacabecera
alter table ventacabecera
add constraint fk_codigo_vendedor
foreign key (CodigoVendedor) references vendedor(IDVendedor);

alter table ventacabecera
add constraint fk_codigo_cliente
foreign key (Codigo_Cliente) references cliente(CodCliente);

alter table ventacabecera
add constraint fk_codigo_tienda
foreign key (Codigo_Tienda) references tienda(IDTienda);

alter table ventacabecera
add constraint fk_codigo_ubigeo_vc
foreign key (Codigo_Ubigeo) references ubigeo(IDUbigeo);

--- tabla ventadetalle

alter table ventadetalle
add constraint fk_id_venta
foreign key (IDVenta) references ventacabecera(Cod_Venta);

alter table ventadetalle
add constraint fk_codigo_producto_vd 
foreign key (CodigoProducto) references producto(IDProducto);


------------------------------- Primary key Detalle

alter table ventadetalle
add constraint pk_ventadetalle
primary key (IDVenta,CodigoProducto);



------------------------------- CHECKS

--- tabla producto
alter table producto
add constraint df_producto 
DEFAULT 'Sin descripcion largo' FOR Descripcion_Articulo_Largo;

alter table producto
add constraint chk_val_producto
CHECK (Val_MonedaNacional > 0 AND Val_MonedaExtranjera > 0);
