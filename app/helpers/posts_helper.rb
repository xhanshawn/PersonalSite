module PostsHelper
  def get_intro(body)
  	t = body.to_s
  	i = 0
  	if (i != -1)
  	  i = t.index('<img')

  	  j = t[i..-1].index('>') if i
  	  
  	  if i and j 
    		if i > 0 
    		  t = t[0..i - 1] + t[(j + i + 1)..-1] 
    		else
    		  t = t[(j + i + 1)..-1] 
    		end
  	  end
  	end
  	
    i = 0
   
    i = t[i + 1..-1].index('</p>')
    
    return t[0..i + 4] if i else t
  end


end

