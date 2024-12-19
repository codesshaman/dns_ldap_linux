#!/bin/bash

dc1="$(grep "DC_NAME" .env | sed -r 's/.{,8}//')"
dc2="$(grep "DC_HOST" .env | sed -r 's/.{,8}//')"
echo $dc1
echo $dc2

# Сканируем все директории, исключая "scripts", скрытые директории и текущую директорию "."
mapfile -t directories < <(find . -mindepth 1 -maxdepth 1 -type d ! -path "./scripts" ! -path "*/.*" ! -path ".")

# Проверка на наличие директорий
if [ ${#directories[@]} -eq 0 ]; then
  echo "Нет доступных директорий."
  exit 1
fi

# Выводим список директорий без ./
echo "Доступные группы:"
for i in "${!directories[@]}"; do
  dir_name=$(basename "${directories[$i]}")
  echo "$i) $dir_name"
done

# Запрашиваем номер директории для выбора
echo "Выберите группу пользователя (введите номер):"
read -r choice

# Проверка корректности выбора
if [[ $choice =~ ^[0-9]+$ ]] && [ $choice -ge 0 ] && [ $choice -lt ${#directories[@]} ]; then
  selected_directory="${directories[$choice]}"
  echo "Вы выбрали группу: $(basename "$selected_directory")"
else
  echo "Некорректный выбор!"
  exit 1
fi

read -p "Введите фамилию и имя пользователя в английской транскрипции: " surname name

# Вывод значений
echo "Фамилия: $surname"
echo "Имя: $name"

# Взять первую букву из первой переменной и перевести в lowercase
first_letter=$(echo "${surname:0:1}" | tr '[:upper:]' '[:lower:]')

# Перевести вторую переменную в lowercase
second_var_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')

# Конкатенировать первую букву и вторую переменную
ncikname="${first_letter}${second_var_lower}"

# Вывести результат
echo "Результат: $ncikname"

echo "$ncikname" >> $selected_directory/$ncikname