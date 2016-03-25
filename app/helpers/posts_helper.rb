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
  	
    last_is_space = true

    i = 0
    n = 0

    while(i < t.length and n < 180)
      
      n += 1 if(t[i] != ' ' and last_is_space) 

      last_is_space = (t[i] == ' ')
      i += 1
    end

    return t[0..i - 1] + "..."
  end


end
