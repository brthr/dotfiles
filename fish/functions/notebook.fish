function notebook --wraps='jupyter notebook --no-browser' --description 'alias notebook jupyter notebook --no-browser'
  jupyter notebook --no-browser $argv; 
end
