#!/usr/bin/env bash

menuLogueado() {
	echo "1) crear usuario"
	echo "2) cambiar contraseña"
	echo "3) logout"
	echo "4) ingresar producto"
	echo "5) vender producto"
	echo "6) filtro de producto"
	echo "7) crear reporte de pintura"
	echo "8) salir"
}

menuSinLog() {
	echo "1) crear usuario"
	echo "2) cambiar contraseña"
	echo "3) login"
	echo "4) salir"
}

crearUsuario(){
    read -r -p "ingrese nombre: " usuario
    grep -Eq "^${usuario}[[:space:]]*:[[:space:]]*[^[:space:]]*$" usuarios.txt 2>/dev/null && 
        echo "El usuario ya existe." && return

    while true; do
        echo "ingrese contraseña: "
        read -r -s  contra
        if [[ -z "$contra" ]] then
            echo "La contraseña no puede estar vacía"
        else break
        fi
    done

    echo "$usuario : $contra" >> usuarios.txt
    echo "Usuario creado exitosamente"
}

cambiarContraseña(){
    read -r -p "ingrese nombre: " usuario
    if grep -Eq "^[[:space:]]*${usuario}[[:space:]]*:[[:space:]]*.*$" usuarios.txt 2>/dev/null; then
	    while true; do
        echo "ingrese nueva contraseña: "
        read -r -s  contra
        if [[ -z "$contra" ]] then
            echo "La contraseña no puede estar vacía"
        else 
            sed -i -E "s|^[[:space:]]*${usuario}[[:space:]]*:[[:space:]]*.*$|${usuario} : ${contra}|" usuarios.txt
            echo "contrasña cambiada exitosamente"
            break
        fi
        done
    fi
}

login(){
    read -r -p "ingrese usuario: " usuario
    if grep -Eq "^[[:space:]]*${usuario}[[:space:]]*:[[:space:]]*.*$" usuarios.txt 2>/dev/null; then
	    while true; do
            echo "ingrese contraseña: "
            read -r -s  contra
            if ! grep -Eq "^[[:space:]]*${usuario}[[:space:]]*:[[:space:]]*${contra}$" usuarios.txt 2>/dev/null; then
                echo "contraseña invalida"
            else 
                break
            fi
        done
        log=1
        usuarioActual=$usuario
    else 
        echo "usuario inválido"
    fi
}

logout(){
    log=0
    usuarioActual="noLogueado"
    echo "adios..."
}

ingresarProducto(){
    read -r -p "ingrese el tipo de producto: " tipo
    codigo="$(echo "$tipo" | cut -c1-3 | tr '[:lower:]' '[:upper:]')"
    read -r -p "ingrese el modelo: " modelo
    read -r -p "ingrese la descripción: " desc
    read -r -p "ingrese la cantidad: " cant
    read -r -p "ingrese el precio: " precio 

    echo "$codigo - $tipo - $modelo - $desc - $cant - \$ $precio" >> productos.txt
}

venderProducto(){
    cantLineas=$(wc -l productos.txt)

    nl -w2 -s ". " productos.txt
    read -r -p "ingrese el numero del producto a vender: " num
    linea=$(sed -n "${num}p" productos.txt)
    total=$(awk '{print $9}' <<<"$linea")
    echo $total
    cod=$(awk '{print $1}' <<<"$linea")
    read -r -p "ingrese la cantidad a vender: " cant

    if (( cant <= total )); then
        total=$(( total - cant ))
        sed -i -E "s/^(${cod})([[:space:]]+[^[:space:]]+){7}([[:space:]]+)[^[:space:]]+/\1\2\3${total}/" productos.txt
    else 
        echo "no podes superar la cantidad actual"
    fi
    
}

log=0
usuarioActual="noLogueado"
while true; do
    if [[ ! -s usuarios.txt ]]; then
        echo "admin : admin" >> usuarios.txt
    fi
    
    if [[ $log -eq 1 ]]; then
        menuLogueado
        read -r -p "[${usuarioActual}] Elegí una opción: " entrada
        case "$entrada" in
            1) crearUsuario ;;
            2) cambiarContraseña ;;
            3) logout ;;
            4) ingresarProducto ;;
            5) venderProducto ;;
            6) echo "" ;;
            7) echo "" ;;
            8) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción inválida" ;;
        esac
    else
        menuSinLog
        read -r -p "[${usuarioActual}] Elegí una opción: " entrada
        case "$entrada" in
            1) crearUsuario ;;
            2) cambiarContraseña ;;
            3) login ;;
            4) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción inválida" ;;
        esac
    fi
done