function exit_on_error {
    if [[ 0"$?" != 0"0" ]]; then
	    echo "ERROR: $@"
	    exit 1
    fi
}
