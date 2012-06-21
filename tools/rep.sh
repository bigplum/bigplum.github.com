for d in `ls _posts`; do
    for f in `ls _posts/$d/*markdown`; do
        #sed -e "s/\(\[bash\]\)/{% highlight bash%}/" $f |sed -e "s/\(\[\/bash\]\)/{% endhighlight %}/" | sed -e "s/\(\[c\]\)/{% highlight c %}/" | sed -e "s/\(\[\/c\]\)/{% endhighlight %}/" | sed -e "s/\(\[python\]\)/{% highlight python %}/" | sed -e "s/\(\[\/python\]\)/{% endhighlight %}/" >> $f.new 
        #mv $f.new $f
    
        #sed -e "s/\(\&quot\;\)/"\""/g" $f | sed -e "s/\(\&amp\;\)/\&/g" | sed -e "s/\(\&gt\;\)/>/g"| sed -e "s/\(\&lt\;\)/</g" >> $f.new

        sed "/wordpress_url: /d" $f >> $f.new
        mv $f.new $f

        sed "/wordpress_id: /d" $f >> $f.new
        mv $f.new $f
    done
done
