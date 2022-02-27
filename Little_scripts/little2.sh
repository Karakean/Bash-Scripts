#!/bin/bash
input=0
while [ $input != 8 ]
do
echo "1. Nazwa pliku: $NAZWA"
echo "2. Katalog: $KATALOG"
echo "3. Maksymalna liczba dni od modyfikacji: $CZAS"
echo "4. Rozmiar rowny: $ROZMIAR"
echo "5. Wlasciciel: $WLASCICIEL"
echo "6. Zawartosc pliku: $ZAWARTOSC"
echo "7. Szukaj"
echo "8. Koniec"
read input
clear
case "$input" in
    1)read NAZWA
        NAME="-name $NAZWA"
        if [ -z $NAZWA ]
        then
        NAME=""
        fi;;
    2)read KATALOG
        CAT="${KATALOG}"
        if [ -z $KATALOG ]
        then
        CAT=""
        fi;;
    3)read CZAS
        TIME="-ctime -$CZAS"
        if [ -z $CZAS ]
        then
        TIME=""
        fi;;
    4)read ROZMIAR
        SIZE="-size ${ROZMIAR}c"
        if [ -z $ROZMIAR ]
        then
        SIZE=""
        fi;;
    5)read WLASCICIEL
        OWNER="-user $WLASCICIEL"
        if [ -z $WLASCICIEL ]
        then
        OWNER=""
        fi;;
    6)read ZAWARTOSC 
        CONTENT="-exec grep -l "$ZAWARTOSC" {} ;"
        if [ -z $ZAWARTOSC ]
        then
        CONTENT=""
        fi;;
    7)SZUKAJ=$(find $CAT -type f $NAME $TIME $SIZE $OWNER $CONTENT)
        if [ -z "$SZUKAJ" ]
        then
        echo "Nie znaleziono pliku."
        else
        echo "Znaleziono plik."
        echo "$SZUKAJ"
        fi;;
    8)input=8;;
esac
done