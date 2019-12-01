for dir in 2018/*
do
	if lua $dir/part_1.lua < $dir/input.txt | diff $dir/answer_1.txt -
	then
		tput setaf 2
		echo $dir/part_1.lua: PASS
		tput sgr0
	else
		tput setaf 1
		echo $dir/part_1.lua: FAIL
		tput sgr0
	fi

	if lua $dir/part_2.lua < $dir/input.txt | diff $dir/answer_2.txt -
	then
		tput setaf 2
		echo $dir/part_2.lua: PASS
		tput sgr0
	else
		tput setaf 1
		echo $dir/part_2.lua: FAIL
		tput sgr0
	fi
done
