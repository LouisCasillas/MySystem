function mydo()
{
	set -g x=8
	echo "--->$x"
	for ((i=0;i<$SET;i++))
	do
		echo "->$i"

		bash <<<$mylambda

	done

	echo "--->$x"
}

SET=7

mylambda=$(cat <<- EOF
	echo 'moo'
	echo "x = $x"

	x=1

	echo 'zoo2'
EOF)

mydo
