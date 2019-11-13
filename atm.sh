pin_try=0
##HELLO
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
  echo "Enter new balance : "
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
  echo "Your balance is $balance"
}

withdraw(){
  echo "--------Withdraw----------"
  echo "Enter withdraw ammount : "
  read amt
  local arr_user_infos
  IFS="|" read -r -a array <<< `cat user_details.txt`
  arr_user_infos=(${array[0]} ${array[1]} ${array[2]})
  remain_balance="$((arr_user_infos[1] - $amt))"
  update_data="${arr_user_infos[0]}|$remain_balance|${arr_user_infos[2]}"
  echo "${update_data}" > user_details.txt  
  if [ ! -e transaction.log ]; then
    `touch transaction.log`
  fi
  current_date=`date +"%D %T"`
  echo "$current_date"
  echo "Balance : ${arr_user_infos[1]}, Withdraw ammount : $1, Remain balance : $remain_balance, Date : $current_date" >> transaction.log
  echo "Withdraw successfully"
}

view_transaction_history(){
  echo "--------View transaction histroy----------"
  if [ ! -e transaction.log ]; then
    echo "You don't have any transaction yet."
  else
    echo `cat transaction.log`
  fi
}


login(){
  echo "--------Login----------"
  login_status=false
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
    login_status=true
    echo "User authorized"
  else
    echo "Enter PIN again"
    if [ "$pin_try" -eq 3 ]; then
      running=0
      echo "$running"
    fi
    ((pin_try++))
  fi
  echo "$login_status"
}

view_info
login


# to update new pin #
update_PIN

# to update balance #
update_balance


check_balance

withdraw

check_balance

view_transaction_history





# to count and access array #
# echo "${#array[@]}"
# echo "${array[1]}"
