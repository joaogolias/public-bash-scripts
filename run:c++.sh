#############################################
# Script for compiling running any c++ file #
#############################################

filepath=""
output=""

######################
# Get options values #
######################
while getopts ":f:o:" opt; do
	case $opt in
	f)
		filepath="$OPTARG"
		;;
	o)
		output="$OPTARG"
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		exit 1
		;;
	esac
done

####################
# Input validation #
####################
if [ -z "$filepath" ]; then
	echo ERROR: "Missing file name. Use -f option to provide it."
	exit 1
fi

if [ -z "$output" ]; then
	output="$(pwd)/build"
fi

absolutefilepath=$(realpath $filepath)

############################################
# Creation of output paths and directories #
############################################

# split string $filepath into $patharr by '/'
IFS='/' read -ra patharr <<<"$filepath"

# last index of $patharr
patharrlength=${#patharr[@]}

i=0
onlyfilename=""

for path in "${patharr[@]}"; do
	if [ "$i" -lt "$((patharrlength - 1))" ]; then
		output="$output/$path"
		mkdir -p "$output"
	else
		# split used to determine the filename
		IFS='.' read -ra filearr <<<"$path"
		onlyfilename="$filearr"
	fi
	i=$((i + 1))
done

######################
# Compiling C++ file #
######################
finaloutputpath="$output/$onlyfilename.out"
g++ -pipe -O2 -std=c++11 "$absolutefilepath" -o "$finaloutputpath"

#######################
# Running output file #
#######################
"$finaloutputpath"
