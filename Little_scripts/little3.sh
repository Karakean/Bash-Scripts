#!/bin/bash
input=0
while [ "$input" != 8 ]
do
o1="1. Nazwa pliku: $NAZWA"
o2="2. Katalog: $KATALOG"
o3="3. Maksymalna liczba dni od modyfikacji: $CZAS"
o4="4. Rozmiar rowny: $ROZMIAR"
o5="5. Wlasciciel: $WLASCICIEL"
o6="6. Zawartosc pliku: $ZAWARTOSC"
o7="7. Szukaj"
o8="8. Koniec"
MENU=("$o1" "$o2" "$o3" "$o4" "$o5" "$o6" "$o7" "$o8")
input=$(zenity --list --title "Wyszukiwarka" --column=MENU "${MENU[@]}" --height 300 --width 350)
case "$input" in
    $o1)NAZWA=$(zenity --entry --title "Wyszukiwarka" --text "Podaj nazwe pliku wraz z rozszerzeniem: ")
        NAME="-name $NAZWA"
        if [ -z $NAZWA ]
        then
        NAME=""
        fi;;
    $o2)KATALOG=$(zenity --entry --title "Wyszukiwarka" --text "Podaj sciezke do pliku: ")
        CAT="${KATALOG}"
        if [ -z $KATALOG ]
        then
        CAT=""
        fi;;
    $o3)CZAS=$(zenity --entry --title "Wyszukiwarka" --text "Podaj maksymalna liczbe dni od ostatniej modyfikacji pliku: ")
        TIME="-ctime -$CZAS"
        if [ -z $CZAS ]
        then
        TIME=""
        fi;;
    $o4)ROZMIAR=$(zenity --entry --title "Wyszukiwarka" --text "Podaj dokladny rozmiar pliku: ")
        SIZE="-size ${ROZMIAR}c"
        if [ -z $ROZMIAR ]
        then
        SIZE=""
        fi;;
    $o5)WLASCICIEL=$(zenity --entry --title "Wyszukiwarka" --text "Podaj wlasciciela pliku: ")
        OWNER="-user $WLASCICIEL"
        if [ -z $WLASCICIEL ]
        then
        OWNER=""
        fi;;
    $o6)ZAWARTOSC=$(zenity --entry --title "Wyszukiwarka" --text "Podaj zawartosc pliku: ")
        CONTENT="-exec grep -l "$ZAWARTOSC" {} ;"
        if [ -z $ZAWARTOSC ]
        then
        CONTENT=""
        fi;;
    $o7)SZUKAJ=$(find $CAT -type f $NAME $TIME $SIZE $OWNER $CONTENT 2>blad.txt | zenity --text-info --title "Wyszukiwarka" --width 300 --height 300)
        if [ -z "$SZUKAJ" ]
        then
        zenity --info --title "Ups..." --text "Nie znaleziono pliku."
        else
        echo $SZUKAJ
        fi;;
    $o8)input=8;;
esac
done