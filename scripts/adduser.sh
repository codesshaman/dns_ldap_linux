#!/bin/bash

dc1="$(grep "DC_NAME" .env | sed -r 's/.{,8}//')"
dc2="$(grep "DC_HOST" .env | sed -r 's/.{,8}//')"

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
  dir="${directories[$choice]}"
  echo "Вы выбрали группу: $(basename "$dir")"
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

dirtext="${dir:2}"

echo "dn: uid=$ncikname,ou=$dirtext,dc=$dc1,dc=$dc2" > $dir/$ncikname
echo "objectClass: inetOrgPerson" >> $dir/$ncikname
echo "objectClass: posixAccount" >> $dir/$ncikname
echo "objectClass: top" >> $dir/$ncikname
echo "cn: $name $surname" >> $dir/$ncikname
echo "uid: $ncikname" >> $dir/$ncikname
echo "objectClass: posixAccount" >> $dir/$ncikname


# Генерация случайного пароля (16 символов)
password=$(openssl rand -base64 16)

# Генерация случайной 16-байтной соли
salt=$(openssl rand -hex 16)

# Конкатенируем пароль и соль
password_and_salt="${password}${salt}"

# Хэшируем с использованием SHA1
hash=$(echo -n "$password_and_salt" | openssl dgst -binary -sha1)

# Генерация SSHA-хэша (хэш + соль в base64)
ssha_hash=$(echo -n "${hash}${salt}" | base64)

# Сохранение пароля в файл
echo "$password" > admin_password.txt

# Создание хэша SSHA для LDAP
ssha_password="{SSHA}${ssha_hash}"

# Выводим результат
echo "SSHA хэш для LDAP: $ssha_password"

# + Создать пользователя в системе
# + Генерировать рандомный пароль вместо ввода
# Проверить uid созданного пользователя
# Записать uid в файл
# Сгенерировать рандомный пароль
# Получить хэш пароля
# Записать хэш в файл
# Вывести пароль в терминал