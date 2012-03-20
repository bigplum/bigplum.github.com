for f in `ls *markdown`; do
    sed -e "s/\(http:\/\/pipablog.tk\/wp-content\)/\/assets/" $f >> $f.new
    mv $f.new $f
done
