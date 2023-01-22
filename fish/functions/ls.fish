function ls --wraps='lsd -lt' --description 'alias ls lsd -lt'
  lsd -lt $argv; 
end
