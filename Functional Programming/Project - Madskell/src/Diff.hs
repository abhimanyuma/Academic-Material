module Diff where
import Root
import Sim

eval (F "diff" [a,V b]) = diff a (V b)  
--Basic rules
diff (C _) (V _) = C 0

diff (V a) (V b) =  if a==b then  C 1 
		else C 0
diff (F f [C _]) (V _) = C 0
diff (F "sin" [V a]) (V b)  = if a==b then  F "cos" [V a] 
			else C 0
diff (F "cos" [V a]) (V b)  = if a==b then  F "-" [C 0, F "sin" [V a] ]
			else C 0
diff (F "tan" [V a]) (V b)  = if a==b then  F "^" [F "sec" [V a] , C 2]
			else C 0
diff (F "cosec" [V a]) (V b)  = if a==b then  F "-" [C 0 ,F "*" [F "cot" [V a] , F "cosec" [V a]]]
			else C 0
diff (F "sec" [V a]) (V b)  = if a==b then  F "*" [F "tan" [V a] , F "sec" [V a]]
			else C 0
diff (F "cot" [V a]) (V b)  = if a==b then  F "-" [C 0, F "^" [F "cosec" [V a] , C 2]]
			else C 0
diff (F "ln" [V a])  (V b)   =  if   a==b then  F "/" [C 1, V a]
			else C 0
diff (F "^" [(V a) , (C y)] ) (V b) = if   a==b then F "*" [(C y) , (   F "^" [(V "x") ,  (C (y-1))]    )]
			      else C 0	
diff (F "^" [(C y), (V a)] ) (V b) = if   a==b then F "*" [(C (log y)) , F  "^" [C y, V a]   ]							      else C 0	
diff (F "sinh" [V a]) (V b)= if   a==b then  F "cosh" [V a]
				else C 0	
diff (F "cosh" [V a]) (V b)= if   a==b then  F "sinh" [V a]
				else C 0	
diff (F "tanh" [V a]) (V b)= if   a==b then  F "^" [F "sech" [V a], C 2]
				else C 0	
diff (F "coth" [V a]) (V b)= if   a==b then  F "-" [C 0, F "^" [F "cosech" [V a], C 2]]
				else C 0	
diff (F "cosech" [V a]) (V b)= if   a==b then  F "-" [C 0, F "*" [F "cosech" [V a], F "coth" [V a]]]
				else C 0	
diff (F "sech" [V a]) (V b)= if   a==b then  F "-" [C 0, F "*" [F "tanh" [V a], F "sech" [V a]]]
				else C 0	

diff (F "invsin" [V a]) (V b)  = if a==b then  F "/" [C 1, F "^" [F "-" [C 1, F "^" [V a, C 2]],C 0.5] ]
			    else C 0
diff (F "invcos" [V a]) (V b)  = if a==b then  F "/" [(C (-1)), F "^" [F "-" [C 1, F "^" [V a, C 2]],C 0.5] ]
			    else C 0
diff (F "invtan" [V a]) (V b)  = if a==b then  F "/" [C 1,   F "+" [C 1, F "^" [V a, C 2]] ] 
			    else C 0
diff (F "invsinh" [V a]) (V b)  = if a==b then  F "/" [C 1, F "^" [F "+" [C 1, F "^" [V a, C 2]],C 0.5] ]
			    else C 0
diff (F "invcosh" [V a]) (V b)  = if a==b then  F "/" [(C (1)), F "^" [F "-" [ (F "^" [V a, C 2]), C 1],C 0.5] ]
			    else C 0
diff (F "invtanh" [V a]) (V b)  = if a==b then  F "/" [C 1,   F "-" [C 1, F "^" [V a, C 2]] ] 
			    else C 0
diff (F "invcosech" [V a]) (V b)  = if a==b then  F "/" [(C (-1)), F "^" [F "+" [C 1, F "^" [V a, C 2]],C 0.5] ]
			    else C 0
diff (F "invcoth" [V a]) (V b)  = if a==b then  F "/" [C 1,   F "-" [C 1, F "^" [V a, C 2]] ] 
			    else C 0
--diff (F "invsech" [V a]) (V b)

-- The fog rule

diff (F f [F g xs]) (V a) = F "*"  [  t , (diff (F g xs)  (V a)) ]  
			where t = substitute (diff   (F f [V a])   (V a)   )  (V a)  (F g xs)
		
--The Chain Rule

diff (F "-" [x])  t=  F "-" [ diff x t]
diff (F "+" [x,y]) t =  F "+" [ diff x t, diff y t]
diff (F "-" [x,y])  t=  F "-" [ diff x t, diff y t]
diff (F "*" [x,y])  t=  F "+" [ F "*" [diff x t ,y] , F "*" [diff y t,x] ]
diff (F "/" [x,y])  t=  F "/" [F "-" [ F "*" [diff x t ,y] , F "*" [diff y t,x] ] , F "^" [y,C 2] ]
diff (F "^" [x,y])   t  = F  "*" [F "^" [x,y],  diff (F "*" [x, F "ln" [y] ] ) t  ]

dif a = diff a (V "x")

substitute  (C c) (V a) (eq) = C c
substitute  (V c) (V a) (eq) = if c == a  then eq
			   else V c
substitute  (F f xs)  (V a) (eq) = F f (fmap (\x -> substitute x (V a) (eq))  xs)





{-
interspase [] = []	
interspase (x:xs) = x++ (interspase xs )

instance Functor Equation where 
	fmap f (C s) = C (f s)
	fmap f (   
-}

{-
diff (F "cos" [a]) (V a) = F "-" [F "sin" [a]]
diff (F "tan" [a])  (V a) = F "sec2" [a]
diff (F "cot" [a]) (V a) = F "cosec2" [a]

-}
--
--diff ( BinOp "." a b ) = 
--diffy [a,(F "." []), b] = [ a, (F "." []) , diff b , (F "+" []) , b ,  (F "." []) , diff a]
{-
diff (F f [F g xs]) (V a) = F "*"  [  t , (diff (F g xs)  (V a)) ]  
			where t = case (diff   (F f [V a])   (V a)   )	of
					
					(F h [V a]) -> (F h  [F g xs])  
					(F h [F h' x] ) -> ( F h [ F h' [F g xs] ] )  -- for handling unary opertors
					(F h [C b, V a]) -> (F h  [C b ,F g xs])  			
-}

  		
