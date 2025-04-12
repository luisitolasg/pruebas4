#!/bin/bash

# ----------------------------------------------
# Sistema de reportes para Ecommerce
# ----------------------------------------------

# Variables globales
ARCHIVO_DATOS="/workspaces/pruebas4/ventas.csv"
REPORTE="/workspaces/pruebas4/reporte_diario.txt"

# Función para generar el TOP 10 de productos más vendidos
generar_top_productos() {
    echo "TOP 10 Productos más vendidos" >> $REPORTE
    echo "--------------------------------------" >> $REPORTE
    tail -n +2 $ARCHIVO_DATOS | awk -F',' '{ productos[$1]+=$4 } END { for (producto in productos) print productos[producto], producto }' | sort -nr | head -10 >> $REPORTE
    echo "" >> $REPORTE
}

# Función para calcular los ingresos por categoría
ingresos_por_categoria() {
    echo "Total de ingresos por categoría" >> $REPORTE
    echo "--------------------------------------" >> $REPORTE
    tail -n +2 $ARCHIVO_DATOS | awk -F',' '{
        if ($2 != "") {
            ingresos[$2]+=$3*$4
        }
    } END {
        for (categoria in ingresos) {
            print categoria, ingresos[categoria]
        }
    }' >> $REPORTE
    echo "" >> $REPORTE
}

# Función para calcular los ingresos por mes
ingresos_por_mes() {
    echo "Total de ingresos por mes" >> $REPORTE
    echo "--------------------------------------" >> $REPORTE
    tail -n +2 $ARCHIVO_DATOS | awk -F',' '{ split($1, fecha, "-"); ingresos[fecha[2]]+=$5 } END { for (mes in ingresos) print "Mes", mes, "Total:", ingresos[mes] }' >> $REPORTE
    echo "" >> $REPORTE
}

# Función para calcular los ingresos por cliente
ingresos_por_cliente() {
    echo "Total de ingresos por cliente" >> $REPORTE
    echo "--------------------------------------" >> $REPORTE
    tail -n +2 $ARCHIVO_DATOS | awk -F',' '{
        # Calcular el gasto total por cliente
        ingresos[$6]+=$3*$4
    } END {
        for (cliente in ingresos) {
            print cliente, ingresos[cliente]
        }
    }' >> $REPORTE
    echo "" >> $REPORTE
}

# Función para calcular los ingresos por departamento
ingresos_por_departamento() {
    echo "Total de ingresos por departamento" >> $REPORTE
    echo "--------------------------------------" >> $REPORTE
    tail -n +2 $ARCHIVO_DATOS | awk -F',' '{ ingresos[$7]+=$5 } END { for (depto in ingresos) print depto, ingresos[depto] }' >> $REPORTE
    echo "" >> $REPORTE
}

# Función principal para generar todos los reportes
generar_reportes() {
    echo "Reporte generado el: $(date)" > $REPORTE
    echo "" >> $REPORTE

    # Llamar a todas las funciones
    generar_top_productos
    ingresos_por_categoria
    ingresos_por_mes
    ingresos_por_cliente
    ingresos_por_departamento
}

# Ejecución del script
generar_reportes