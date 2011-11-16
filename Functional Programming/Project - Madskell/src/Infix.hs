module Infix where 
import Root
convert (C a) = show a 
convert (F a [b, c] ) =  (convert b ) ++ a ++ (convert c )

type Prod = [Equation]
type SOP  = [Prod]
--sm::SOP->SOP

--sm _ [] =[]
sm  xs ys = [(similar xs ys), substractArray xs ys , substractArray ys xs]  

substract [] _ = []
substract (x:xs) y  = if x ==y then xs
		else x:(substract xs y) 
similar [] ys = []
similar (x:xs) ys = if x `elem` ys then x:(similar xs ys)
		else similar xs ys
substractArray xs [] = xs
substractArray xs (y:ys) = substractArray (substract xs y) ys 


apply::Prod->Prod->SOP 
apply xs ys = case ( sm xs ys) of
		[] -> []
--		([si, [x], [] ]) -> [si, [F "+" [x, C 1] ]
--		([si, [], [x] ]) -> [si, [F "+" [x, C 1] ]
 