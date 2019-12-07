if [ $# -eq 0 ]
then
  days=2019/12/*
else
  days=$*
fi

for day in $days
do
  if lua $day/part_1.lua < $day/input.txt | diff $day/answer_1.txt -
  then
    tput setaf 2
    echo $day/part_1.lua: PASS
    tput sgr0
  else
    tput setaf 1
    echo $day/part_1.lua: FAIL
    tput sgr0
  fi

  if lua $day/part_2.lua < $day/input.txt | diff $day/answer_2.txt -
  then
    tput setaf 2
    echo $day/part_2.lua: PASS
    tput sgr0
  else
    tput setaf 1
    echo $day/part_2.lua: FAIL
    tput sgr0
  fi
done
