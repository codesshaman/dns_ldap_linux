#!/bin/bash

# Запрашиваем ввод строки
echo "Введите имена групп (с маленькой буквы):"
read -r input_string

# Разделяем строку на слова и создаем директории
for word in $input_string; do
  if [ ! -d "$word" ]; then
    echo "$word" >> .gitignore
    mkdir "$word"
    echo "Создана директория: $word"
  else
    echo "Директория $word уже существует."
  fi
done