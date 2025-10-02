<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html>
      <head>
        <title>Tarea 5 - LMSGI - Curso 2022-23</title>
        <style>
          table, th, td {
            width:500px;
            margin: 0 auto;
            text-align: center;
            border: 1px solid black;
            border-collapse: collapse;
          }
          th {
            color: white;
            background-color:grey;
          }
          .urgente {
            color: red;
            background-color:yellow;
          }
          .nocturno {
            color: white;
            background-color:black;
          }
        </style>
      </head>
      <body>
        <header>
          <h2>Lenguaje de Marcas y Sistemas de Gestión de Información</h2>
          <h2>Tarea 5: XPath y XSLT</h2>
          <h2>Autor/a: Morales Cruz, Dayro</h2>
        </header>
        <h3>A. Lista ordenada por precio y apellido de los envíos a Sevilla. 
          Indicar el número de orden (con número), el precio, la moneda, el 
          apellido y el nombre. El orden será de mayor a menor precio y si 
          tienen el mismo precio por orden alfabético de apellido. </h3>
        <h5>Formato:<br/> 1) 33 euros - Sánchez, Carlos.</h5>
        <br/><br/>
        
<!-- COMENTARIOS
  1.- Con for-each seleccionamos los envíos para la provincia de Sevilla.
  2.- Ordenamos por precio de forma descendente para ir de mayor a menor y por apellidos de forma ascendente para ordenarlo alfabéticamente.
  3.- Extraemos los datos requeridos: posición, precio, moneda, apellidos y nombre.
-->

        <xsl:for-each select="//envio[provincia='Sevilla']">
          <xsl:sort select="number(precio)" data-type="number" order="descending"/>
          <xsl:sort select="apellido" data-type="text" order="ascending"/>
          <xsl:value-of select="position()"/>
          <xsl:text>) </xsl:text>
          <xsl:value-of select="precio"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="precio@moneda"/>
          <xsl:text> euros - </xsl:text>
          <xsl:value-of select="apellido"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="nombre"/>
          <xsl:text>. </xsl:text>
         </xsl:for-each>


        <h3>B. Número de envíos urgentes a Cádiz y su porcentaje respecto al 
          total de envíos a Cádiz</h3>
        <h5>Formato:<br/> Hay 4 envíos urgentes a Cádiz, que suponen el 28.57% 
        de los 14 envíos totales registrados a Cádiz.</h5>
        <br/><br/>
        
<!-- COMENTARIOS
  1.- Creamos la variable "envios_cadiz" para seleccionar envíos a Cádiz.
  2.- Creamos otra variable "envios_urgentes_cadiz" para los envíos de tipo urgente a Cádiz.
  3.- Utilizaremos Concat para concatenar el resultado y usaremos $ para mostrar los resultados.
-->

        <xsl:variable name="envios_cadiz" select="//envio[contains(provincia='Cádiz')]"/>
        <xsl:variable name="envios_urgentes_cadiz" select="//envio[contains(provincia='Cádiz' and prioridad='Urgente')]"/>
        <xsl:value-of select="concat('Hay ', count($envios_urgentes_cadiz), ' envíos urgentes a Cádiz, que suponen el ', format-number(count($envios_urgentes_cadiz) div count($envios_cadiz) * 100, '0.00'), '% de los ', count($envios_cadiz), ' envíos totales registrados a Cádiz.')"/>
        

        <h3>C. Lista ordenada (por código de envío) con el tipo de prioridad, 
          la provincia, el nombre y el apellido de todos los envío cuyo nombre 
          comience por 'A' y tengan una prioridad 'Normal', o 
          su apellido contenga una 'a' y la provincia sea 'Almería' o 'Granada'.
        </h3>
        <h5>Formato:<br/> 1.- (DBD72R - 24_horas - Granada). Carlos Cano.</h5>
        <br/><br/>
        
<!-- COMENTARIOS
  1.- Creamos una condición para los envíos que cuyo nombre comieza con A y prioridad normal. Y otra con apellidos que contiengan a y provincia Almería o Granada.
  2.- Ordenamos por código.
  3.- Extraemos los datos requeridos: código, prioridad, provincia, nombre, apellido.
-->

        <xsl:for-each select="(//envio[starts-with(nombre, 'A') and prioridad='Normal']) | (//envio[contains(apellido, 'a') and (provincia='Almería' or provincia='Granada')])" >
          <xsl:sort select="@codigo" />
          <xsl:value-of select="position()"/>
          <xsl:text>.- (</xsl:text>
          <xsl:value-of select="@codigo"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="prioridad"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="provincia"/>
          <xsl:text>). </xsl:text>
          <xsl:value-of select="nombre"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="apellido"/>
          <xsl:text>.</xsl:text>
        </xsl:for-each>


        <h3>D. Lista de todas las provincias (ordenadas alfabeticamente) con su 
          número de envíos, ingresos totales (suma de todos sus precios) e 
          ingreso medio</h3>
        <h5>Formato:<br/> Almería: 11 envíos. Ingresos totales: 229 euros. 
        Ingreso medio: 20.82 euros.</h5>
        <br/><br/>

<!-- COMENTARIOS
  1.- Creamos la clave "enviosPorProvincia" y los agrupamos con "." con el comando use para que recoja todo el texto.
  2.- Seleccionamos todos los elementos de provincia y los comparamos con el primer elemento de la lista que tienen claves iguales.
  3.- Creamos las variables necesarias requeridas y ordenamos por fecha.
  4.- Utilizamos concat para concatenar los resultados con las palabras para crear la frase requerida.
-->   

        <xsl:key name="enviosPorProvincia" match="//envio/provincia" use="."/> 
        <xsl:for-each select="//envio/provincia[generate-id()=generate-id(key('envioPorProvincia',.)[1])]">
          <xsl:sort select="." data-type="text" order="ascending"/>
          <xsl:variable name="cantidadEnvios" select="count(//envio[provincia=current()])" />
          <xsl:variable name="sumaEnvios" select="sum(//envio[provincia=current()]/precio)" />
          <xsl:variable name="mediaEnvios" select="$suma-envios div $cantidad-envios" />
          <xsl:value-of select="." />
          <xsl:text>: </xsl:text>
          <xsl:value-of select="$cantidadEnvios" />
          <xsl:text> envíos. Ingresos totales: </xsl:text>
          <xsl:value-of select="$sumaEnvios" />
          <xsl:text> euros. Ingreso medio: </xsl:text>
          <xsl:value-of select="format-number($mediaEnvios, '0.00')" />
          <xsl:text> euros.</xsl:text>
        </xsl:for-each>


        <h3>E. Crear una tabla, ordenada por fecha de entrega, de los envíos a 
          Almería. La tabla incluirá las columnas: fecha de entrega, provincia, 
          código de envío y prioridad. Estilos: La tabla deberá usar los estilos 
          definidos en la plantilla que se proporciona en el ejercicio. Los 
          elementos tabla y las celdas usarán los estilos de los selectores 
          'table','th' y 'td'. La cabecera usará el estilo del selector 'th'. 
          Si la prioridad de un envío es 'Urgente' esa celda usará el estilo del 
          selector '.urgente'. Si la prioridad de un envío es 'Nocturno' esa 
          celda usará el estilo del selector '.nocturno'.</h3>
          <h5>Formato:</h5>
          <table>
            <tr>
                <th>Fecha</th><th>Provincia</th><th>Código de envío</th><th>Prioridad</th>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td>Normal</td>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td>Normal</td>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td class="urgente">Urgente</td>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td class="nocturno">Nocturno</td>
            </tr>
          </table>
          <br/><br/>
        
<!-- COMENTARIOS
  1.- Utilizaremos <th> para insertar el nombre de las columnas de nuestra tabla.
  2.- A través del comando for-each seleccionamos  la provincia de ALmería y ordenamos or fecha.
  3.- Creamos un condicional para Urgente y para Nocturno y les aplicamos el estilo aportado al principio de la plantilla. En caso contrario no aplicamos nada.
-->

        <table>
          <tr>
            <th>Fecha</th><th>Provincia</th><th>Código de envío</th><th>Prioridad</th>
          </tr>
          <xsl:for-each select="//envio[provincia='Almería']">
          <xsl:sort select="fecha_entrega" />
            <tr>
              <td><xsl:value-of select="fecha_entrega" /></td>
              <td><xsl:value-of select="provincia" /></td>
              <td> <xsl:value-of select="@codigo" /> </td>
              <xsl:choose>
                <xsl:when test="prioridad = 'Urgente'">
                  <td class="urgente"><xsl:value-of select="prioridad" /></td>
                </xsl:when>
                <xsl:when test="prioridad = 'Nocturno'">
                  <td class="nocturno"><xsl:value-of select="prioridad" /></td>
                </xsl:when>
                <xsl:when test="prioridad!='Urgente' and prioridad!='Nocturno'">
                  <td><xsl:value-of select="prioridad" /></td>
                </xsl:when>
              </xsl:choose>
            </tr>              
          </xsl:for-each>        
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>