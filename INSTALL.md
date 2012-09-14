# Installation

You'll be installing localwiki on a Vagrant VM. On your host machine you'll need to install [Vagrant](http://vagrantup.com) and [git](http://git-scm.com) (lets hope you have that already :) )

_After installing Vagrant and git. Prepare yourself to download ~600MB and take 30+ min:_


> host$: cd [to wherever you keep your projects]  
> host$: git clone https://github.com/friendlycode/viget-lw.git viget-lw/  
> host$: cd viget-lw  
> host$: vagrant up  

_After some time you'll be prompted to ssh into the vm_

> `new terminal` host$: cd [to your projects/viget-lw]  
> host$: vagrant ssh  
> vm$: sudo screen -r installer  

*Follow install instructions. When the prompt is finished and returns you to the vagrant terminal, close it.*  

# Start localwiki

*Back to first host terminal*
> host$: vagrant ssh  
> vm$: localwiki-manage runserver 0.0.0.0:8000  

host web browser: http://localhost:8000