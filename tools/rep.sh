for f in `ls *markdown`; do
    sed -e "s/\(\[bash\]\)/{% highlight bash%}/" $f |sed -e "s/\(\[\/bash\]\)/{% endhighlight %}/" | sed -e "s/\(\[c\]\)/{% highlight c %}/" | sed -e "s/\(\[\/c\]\)/{% endhighlight %}/" >> $f.new 
    mv $f.new $f

    sed -e "s/\(\&quot\;\)/"\""/g" $f | sed -e "s/\(\&amp\;\)/\&/g" | sed -e "s/\(\&gt\;\)/>/g"| sed -e "s/\(\&lt\;\)/</g" >> $f.new

    mv $f.new $f
done
