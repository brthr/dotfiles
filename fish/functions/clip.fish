function clip --wraps='xclip -selection clipbord' --description 'alias clip xclip -selection clipbord'
  xclip -selection clipbord $argv; 
end
