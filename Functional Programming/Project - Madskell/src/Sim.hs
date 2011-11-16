module Sim where
import Root

simplfy (F "*" [C 0, _]) = C 0    
simplfy (F "*" [_, C 0]) = C 0
simplfy (F "*" [C 1, x]) = x    
simplfy (F "*" [x, C 1]) = x

simplfy (F "+" [ C 0, x] ) = x
simplfy (F "+" [ x,C 0] ) = x
simplfy (F "*" [F "/" [ C 1,x], y] ) = F "/" [y,x]
simplfy (F "^" [ x,C 0] ) = C 1
simplfy (F "^" [ x,C 1] ) = x
simplfy (F a xs) =  (F a  $ fmap simplfy xs )
simplfy a = a	




{-
simplfy (F "*" [x, y] ) = simplfy (F "*" [simplfy x, simplfy y])
			where 
	   			let
					a =  simplfy x
			            		b =  simplfy y
-}

	--		where  t = simplfy x

