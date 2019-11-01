pin_try=0  
ogin_status=0

# read file #
read_file(){
  IFS="|" read -r -a array <<< `cat user_details.txt`

  # to iterate array #
  # for element in "${array[@]}"
  # do
  #     echo "$element"
  # done
}

view_info(){
  if [ -e user_details.txt ]; then
    echo  `cat user_details.txt`
  fi
}

update_PIN(){
  echo "--------Update PIN----------"
  echo "Enter new PIN : "
  read PIN
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  update_data="${arr_user_infos[0]}|${arr_user_infos[1]}|$PIN"
  echo "${update_data}" > user_details.txt
  echo "PIN successfully updated!"
}

update_balance(){
  echo "--------Update balance----------"
  echo "Enter new balance : $"
  read bal
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  update_data="${arr_user_infos[0]}|$bal|${arr_user_infos[2]}"
  echo "${update_data}" > user_details.txt
  echo "Balance successfully updated!"
}

check_balance(){
  echo "--------Check balance----------"
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  balance="${arr_user_infos[1]}"
  echo "Your balance is \$$balance"
}

withdraw(){
  echo "--------Withdraw----------"
  echo "Enter withdraw ammount : $"
  read amt
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  if [ $amt -le ${array[1]} ]; then
  remain_balance="$((arr_user_infos[1] - $amt))"
  update_data="${arr_user_infos[0]}|$remain_balance|${arr_user_infos[2]}"
  echo "${update_data}" > user_details.txt
  if [ ! -e transaction.log ]; then
    `touch transaction.log`
  fi
  current_date=`date +"%D %T"`
  echo "$current_date"
  echo "Balance :\$${arr_user_infos[1]}, Withdraw ammount : \$$amt, Remain balance : \$$remain_balance, Date : $current_date" >> transaction.log
  echo "Withdraw successfully"
  else
    echo "Your balance is insufficient"
  fi
}

view_transaction_history(){
  echo "--------View transaction histroy----------"
  if [ ! -e transaction.log ]; then
    echo "You don't have any transaction yet."
  else
	while IFS= read -r line; do
    echo "$line"
  done < "transaction.log"
    #echo `cat transaction.log`
  fi
}


login(){
  echo "--------Login----------"
  if [ ! -e user_details.txt ]; then
      echo "creating new file..."
      echo `touch user_details.txt`
      echo "Sokha|300|1234" >> user_details.txt
  fi
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  echo "Enter PIN code:"
  read PIN
  if [ "$PIN" = "${arr_user_infos[2]}" ]; then
    login_status=1
  else
    echo "Enter PIN again, you have $((2-pin_try)) time(s) to try"
    ((pin_try++))
  fi
}

loop_menu(){
    clear
    echo "Choose operation"
    echo "1. Check balance"
    echo "2. Withdraw"
    echo "3. Transaction history"
    echo "4. update PIN"
    echo "5. exit"
    read -p "Select an option : " option

    case $option in
        "1")
            check_balance
        ;;
        "2")
            withdraw
        ;;
        "3")
            view_transaction_history
        ;;
        "4")
            update_PIN
        ;;
	"5")
		exit
	;;
        *)
            echo "Invalid choice"
    esac
    read -n 1 -s -r -p "Press any key!"
}

for((;;))
do
	if [ "$pin_try" -lt 3 ]; then
		if [[ "$login_status" = 1 ]]; then
			break
		fi
		login
	else
		echo "Exiting program..."
		exit
	fi
done
read -n 1 -s -r -p "Press any key!"
for((;;))
do
	loop_menu
done
