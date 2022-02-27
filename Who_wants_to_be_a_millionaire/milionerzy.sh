#!/bin/bash
#Author: Mikolaj Nowak
help() {
    echo "Pomoc"
    echo "Aby odpowiedzien na pytanie, wybierz jedna z czterech dostepnych odpowiedzi (A,B,C,D)." 
    echo "Jesli nie jestes pewny, skorzystaj z ktoregos z dostepnych kol ratunkowych."
    exit
}
ver() {
    echo "Milionerzy wersja 1.0"
    echo "Autor: Mikolaj Nowak"
    exit
}
while getopts hvi:o: OPT; do
    case $OPT in
        h) help;;
        v) ver;;
        *) echo "Nie ma takiej opcji."
        exit;;
    esac
done
file='pytania.txt'
declare -a content
declare -a ansA
declare -a ansB
declare -a ansC
declare -a ansD
declare -a correct
declare -a ff1
declare -a ff2
declare -a audience1
declare -a audience2
declare -a audience3
declare -a audience4
declare -a phone
declare -a prize=(0 500 1000 2000 5000 10000 20000 40000 75000 125000 250000 500000 1000000)
declare -a lifeline=(0 0 0)
line_number=1
question_number=0
success=1
while read line; do
    case $line_number in
        1) content[question_number]=$line;;
        2) ansA[question_number]=$line;;
        3) ansB[question_number]=$line;;
        4) ansC[question_number]=$line;;
        5) ansD[question_number]=$line;;
        6) correct[question_number]=$line;;
        7) ff1[question_number]=$line;;
        8) ff2[question_number]=$line;;
        9) audience1[question_number]=$line;;
        10) audience2[question_number]=$line;;
        11) audience3[question_number]=$line;;
        12) audience4[question_number]=$line;;
        13) phone[question_number]=$line;;
    esac
    if [[ $line_number -eq 13 ]]
    then
        line_number=0
        question_number=$((question_number+1))
    fi
    line_number=$((line_number+1))
done < $file
j=0
while [ $j -lt 12 ] && [ $success -eq 1 ]
do
    a1="${ansA[j]}"
    a2="${ansB[j]}"
    a3="${ansC[j]}"
    a4="${ansD[j]}"
    a5="Kolo ratunkowe: Pytanie do publicznosci"
    a6="Kolo ratunkowe: Pol na pol"
    a7="Kolo ratunkowe: Telefon do przyjaciela"
    answer=("$a1" "$a2" "$a3" "$a4" "$a5" "$a6" "$a7")
    choice=$(zenity --list --column="Wybierz opcje z listy:" --text="${content[j]}" "${answer[@]}" --title="Milionerzy" --width=300 --height=300)
    case "$choice" in
        $a1|$a2|$a3|$a4)
            if [[ "$choice" == "${correct[j]}" ]] && [[ $j -lt 11 ]]
            then
                zenity --question --text="Gratulacje, twoja odpowiedz jest poprawna! Obecnie masz ${prize[j+1]} PLN. Za chwile mozesz uslyszec pytanie o ${prize[j+2]} PLN. Czy chcesz kontynuowac?" --width=300
                if [ $? = 0 ]
                then
                    j=$((j+1))
                else
                    zenity --info --text="Zrezygnowales z dalszego udzialu w grze. Twoja wygrana to ${prize[j+1]} PLN." --width=300
                    success=0
                    break
                fi
            elif [[ "$choice" == "${correct[j]}" ]]
            then
                j=$((j+1))
            else
                if [[ "$j" -ge "6" ]]
                then
                    guaranteed=7
                elif [[ "$j" -ge "1" ]]
                then
                    guaranteed=2
                else
                    guaranteed=0
                fi
                zenity --info --text="Niestety, to niepoprawna odpowiedz. Odpadasz z teleturnieju. Twoja wygrana to: ${prize[guaranteed]} PLN." --width=300
                success=0
                break
            fi
            ;;
        $a5)
            if [[ "${lifeline[0]}" == "0" ]]
            then
                lifeline[0]=1
                zenity --info --text="`printf "${audience1[j]}\n${audience2[j]}\n${audience3[j]}\n${audience4[j]}"`" --title="Pytanie do publicznosci." --width=300
            else
                zenity --error --text="Pytanie do publicznosci zostalo juz uzyte!" --title="Blad" --width=300
            fi
            ;;
        $a6)
            if [[ "${lifeline[1]}" == "0" ]]
            then
                lifeline[1]=1
                zenity --info --text="`printf "${ff1[j]}\n${ff2[j]}"`" --title="Pol na pol." --width=300
            else
                zenity --error --text="Pol na pol zostalo juz uzyte!" --title="Blad" --width=300
            fi
            ;;
        $a7)
            if [[ "${lifeline[2]}" == "0" ]]
            then
                lifeline[2]=1
                zenity --info --text="${phone[j]}" --title="Telefon do przyjaciela." --width=300
            else
                zenity --error --text="Telefon do przyjaciela zostal juz uzyty!" --title="Blad" --width=300
            fi
            ;;
    esac
done
if [[ $success -eq 1 ]]
then
    zenity --info --text="Gratulacje, zostales milionerem!" --width=300
fi
