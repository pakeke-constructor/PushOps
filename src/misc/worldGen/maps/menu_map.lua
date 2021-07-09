



local TMP = [[

                                 ~~~~~~~~~        ~
       ~~~~~~~~~~               ~~~%%%~~~~~
    ~~~~~~~~~~~~~~~            ~~~%% %%%%~~~
   ~~~~%%%%%%%%%~~~           ~~~~%     %%~~~~
    ~~%%       %%%~~~~      ~~~~~%%      %~~~~
    ~~%          %~~~~      ~~~~%%       %~~~
    ~~%          %~~~~      ~~~~%        %~~~
    ~~%          %~~~~~~~~~~~~~%%        %~~~
    ~~%          %~~%%%%%~~~~~%%         %~~~
    ~~%          %~~%   %%~~~%%          %~~~~
   ~~~%          %~~%    %%%%%   %%      %~~~     
   ~~~%          %~~%           %%%%%   %%~~~     
   ~~~%          %~~%         %%%~~~%%%%%~~~~     
   ~~~%%%%     %%%~%%        %%~~~~~~~~~~~~~     
    ~~~~~%%%%%%%~~%%         %%~~~  ~~~~~        
      ~~~~~~~~~~~%%           %%~~~            
               ~~%             %~~~           
    ~~~~~~~~  ~~~%             %%~~~
   ~~~~~~~~~~~~~~%              %~~
  ~~~~%%%%%%%%%%%%%%      L   %~~~          
  ~~~~%^    H   ^ %%            %~~~~          
  ~~~~%^          %%       ^    %%~~ ~ ~ ~
  ~~~~%           %%    ^t^ ^    %%~~~~~~~~~~~~~~~
   ~~~%           %%   ^ ^^   ^   %%%^^%%%%%%%%~~~
   ~~~%^^         %%  ^  &   ^ ^^^^ %%%%^    ^%%~~~
   ~~~%^    S    ^^^ ^   c    ^   ^^ ^    0   ^%~~~
   ~~~%^         ^%%%P        ^ %%%^^^        ^%~~~
   ~~~%^^   C   ^^%~%^^  b   ^ %%~%%%%^ 1^2 3^ %~~~
   ~~~%^          %~%^      ^P %~~ ~~% ^^^     %~~~
   ~~~%   ^ ^   ^ %~%P^^ @  ^ %%~~ ~%%  4 5^6^ %~~~
   ~~~%  ^   ^^^ ^%~%    a    %~~  ~%^ ^   ^ ^ %~~~
   ~~~%    ^ ^^ ^^%~%% ^^  ^ %%~~  ~%% ^7 8 9 %%~~~
   ~~~%%%%%%%  %%%%~~%^ ^ ^ %%~~~  ~~%^  ^ ^  %~~~~
  ~~~~%           %~~%%%%%%%%~~~  ~~~%%% ^^ %%%~~~
  ~~~~%           %~~~~^^ ^ ~~~   ~~~~~%%%%%%~~~~~
  ~~~~%           %~~~ ~~~~ ~     ~~~~~~~~~~~~~~~
  ~~~~%  credits  %~~~                ~~~~~~  
  ~~~~%           %~~~                        
  ~~~~%           %~~~~                        
  ~~~~%           %~~~                        
  ~~~~%           %~~~                        
  ~~~~%           %~~~                        
  ~~~~%%%%%%%%%%%%~~~                        
    ~~~~~~~~~~~~~~~~
    ~~~~~~~~~~~~~~~                    
]]




local s = [[
~~~~~~~~~~~~~~~~~~~~~~~~~~........
~~~~~~~~~~~~~~~~~~~~~~~~~~........
~~%%%%%%%%%%%%%%%%%%%%%%~~........
~~%...l^^p.^^..^..^..^.%~~....l...
~~%^l.pp^..p..^..^..^..%~~........
~~%..^...p..^^.^.^p.^..%~~.....l..
~~%..pp.+.^l..^..^^.+.l%~~........
~~%..^^^.p.^..p.^.p^^^.%~~....l...
~~%..^..^p.p....^p^p^..%~~....l...
~~%.^^p.l^^^pp.^l.^.^^.%~~........
~~%..l^^p^p^p^.^^.^...l%~~.l......
~~%..^^^.p+..p..^p..^..%~~....l...
~~%.^.^.^pp^p.^.^.^^.l.%~~.....l..
~~%..^...p.^.^+.^p..^..%~~....l...
~~%l.^lp^..t...^.l.^..l%~~l.^.....
~~%..^.lp..&..^^..^..^l%~~.l..^...
~~%.pl...^.^^^.^^.^..ll%~~~~~~~~~~
~~%%p.^p^..3....L.^.^  %%%%%%%%%%%
~~~%%l^.... .......^^............%
~~~~%%l^^..2......^...^.^.^.^.^..%
~~~~~%%^^.. ..^.^.^.^....^.^..^..%
~~~~~~%%^..1.^.^^p....^...X......%
~~~~~~~%%%...%%%%%%%.....^^^.....%
.....l.ll%.@.%l^^l.%.p.^^....^.^.%
....l.^l.%.^^%.ll^l%......^...^..%
.....lll.%%%%%l^.l.%%%%%%%%%%%%%%%
........^l^.^^.l..................
l  l  l llll ll ll l l l ll.......
]]



local k = {}

for line in TMP:gmatch("[^\n]+") do
    local n = {}
    for i=1,line:len() do
        table.insert(n, line:sub(i,i))
    end
    table.insert(k,n)
end

return k


