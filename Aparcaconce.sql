

CREATE TABLE Usuario (
    Id_usuario INT PRIMARY KEY IDENTITY(1,1),
    Rut VARCHAR(12) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Telefono VARCHAR(15),
    Correo VARCHAR(255) NOT NULL UNIQUE,
    Rol VARCHAR(50),
    Contrasena NVARCHAR(255) NOT NULL
);

CREATE TABLE Datos_facturacion (
    Id_datos INT PRIMARY KEY IDENTITY(1,1),
    Id_usuario INT NOT NULL UNIQUE,
    Rut VARCHAR(12) NOT NULL,
    Razon_social NVARCHAR(255) NOT NULL,
    Giro NVARCHAR(255),
    Direccion NVARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    CONSTRAINT fk_datos_usuario
        FOREIGN KEY (Id_usuario)
        REFERENCES Usuario(Id_usuario)
);

CREATE TABLE Estacionamiento (
    Id_estacionamiento INT PRIMARY KEY IDENTITY(1,1),
    Id_usuario_propietario INT NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    Calle NVARCHAR(255) NOT NULL,
    N_estacionamiento VARCHAR(20),
    Largo DECIMAL(5, 2),
    Ancho DECIMAL(5, 2),
    Seguridad NVARCHAR(100),
    Tipo_cobertura NVARCHAR(100),
    CONSTRAINT fk_est_usuario_prop
        FOREIGN KEY (Id_usuario_propietario)
        REFERENCES Usuario(Id_usuario)
);

CREATE TABLE Vehiculo (
    Id_vehiculo INT PRIMARY KEY IDENTITY(1,1),
    Id_usuario_propietario INT NOT NULL,
    Patente VARCHAR(10) NOT NULL UNIQUE,
    Marca VARCHAR(100),
    Color VARCHAR(50),
    Tipo_vehiculo VARCHAR(100),
    CONSTRAINT fk_veh_usuario_prop
        FOREIGN KEY (Id_usuario_propietario)
        REFERENCES Usuario(Id_usuario)
);

CREATE TABLE Imagen_Estacionamiento (
    Id_imagen INT PRIMARY KEY IDENTITY(1,1),
    Id_estacionamiento INT NOT NULL,
    Url_imagen VARCHAR(1024) NOT NULL,
    Descripcion NVARCHAR(255),
    CONSTRAINT fk_img_estacionamiento
        FOREIGN KEY (Id_estacionamiento)
        REFERENCES Estacionamiento(Id_estacionamiento)
        ON DELETE CASCADE
);

CREATE TABLE Publicacion (
    Id_publicacion INT PRIMARY KEY IDENTITY(1,1),
    Id_estacionamiento INT NOT NULL UNIQUE,
    Id_usuario_publicador INT NOT NULL,
    Titulo NVARCHAR(255) NOT NULL,
    Descripcion NVARCHAR(MAX),
    Precio DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_pub_estacionamiento
        FOREIGN KEY (Id_estacionamiento)
        REFERENCES Estacionamiento(Id_estacionamiento),
    CONSTRAINT fk_pub_usuario
        FOREIGN KEY (Id_usuario_publicador)
        REFERENCES Usuario(Id_usuario)
);

CREATE TABLE Contrato (
    Id_contrato INT PRIMARY KEY IDENTITY(1,1),
    Id_publicacion INT NOT NULL,
    Id_usuario_arrendatario INT NOT NULL,
    Id_vehiculo INT NOT NULL,
    Fecha_inicio DATE NOT NULL,
    Fecha_termino DATE NOT NULL,
    Monto_total_contrato DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_con_publicacion
        FOREIGN KEY (Id_publicacion)
        REFERENCES Publicacion(Id_publicacion),
    CONSTRAINT fk_con_usuario
        FOREIGN KEY (Id_usuario_arrendatario)
        REFERENCES Usuario(Id_usuario),
    CONSTRAINT fk_con_vehiculo
        FOREIGN KEY (Id_vehiculo)
        REFERENCES Vehiculo(Id_vehiculo)
);

CREATE TABLE Pago (
    Id_pago INT PRIMARY KEY IDENTITY(1,1),
    Id_contrato INT NOT NULL,
    Monto_pagado DECIMAL(12, 2) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    Fecha_pago DATETIME DEFAULT GETDATE(),
    Metodo_pago VARCHAR(100),
    Periodo_pagado VARCHAR(50),
    CONSTRAINT fk_pago_contrato
        FOREIGN KEY (Id_contrato)
        REFERENCES Contrato(Id_contrato)
);

CREATE TABLE Documento_tributario (
    Id_documento INT PRIMARY KEY IDENTITY(1,1),
    Id_pago INT NOT NULL UNIQUE,
    Id_datos INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Folio VARCHAR(100) NOT NULL,
    Fecha_emision DATE NOT NULL,
    Monto_neto DECIMAL(12, 2) NOT NULL,
    IVA DECIMAL(12, 2) NOT NULL,
    Pdf_url VARCHAR(1024),
    CONSTRAINT fk_doc_pago
        FOREIGN KEY (Id_pago)
        REFERENCES Pago(Id_pago),
    CONSTRAINT fk_doc_datos
        FOREIGN KEY (Id_datos)
        REFERENCES Datos_facturacion(Id_datos)
);

CREATE TABLE Conversacion (
    Id_conversacion INT PRIMARY KEY IDENTITY(1,1),
    Id_publicacion INT NOT NULL,
    CONSTRAINT fk_conv_publicacion
        FOREIGN KEY (Id_publicacion)
        REFERENCES Publicacion(Id_publicacion)
);

CREATE TABLE Usuario_Conversacion (
    Id_usuario INT NOT NULL,
    Id_conversacion INT NOT NULL,
    PRIMARY KEY (Id_usuario, Id_conversacion),
    CONSTRAINT fk_uc_usuario
        FOREIGN KEY (Id_usuario)
        REFERENCES Usuario(Id_usuario),
    CONSTRAINT fk_uc_conversacion
        FOREIGN KEY (Id_conversacion)
        REFERENCES Conversacion(Id_conversacion)
);

CREATE TABLE Mensaje (
    Id_mensaje INT PRIMARY KEY IDENTITY(1,1),
    Id_conversacion INT NOT NULL,
    Id_usuario_emisor INT NOT NULL,
    Contenido_mensaje NVARCHAR(MAX) NOT NULL,
    Fecha_envio DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_msg_conversacion
        FOREIGN KEY (Id_conversacion)
        REFERENCES Conversacion(Id_conversacion),
    CONSTRAINT fk_msg_usuario
        FOREIGN KEY (Id_usuario_emisor)
        REFERENCES Usuario(Id_usuario)
);