module Root where
data Equation = C Double
	| V String 
	| F String [Equation]
	| O Char
        deriving (Show)

type Binding = (String, Double)

data Container = Solve  Equation
               | Eval   Equation [Binding]
               | Plot   Equation 
               | Plot2d Equation
               deriving (Show)
{--
instance Show Equation where
	show  (C a) = show a
	show  (V a )= a  
	--show  (Unifun f eq)  = f ++ "(" ++ (show eq) ++ ")" 
	--show  (Binfun  f eq1 eq2) =  f ++ "(" ++ (show eq1) ++ "," ++ (show eq2) ++ ")"   
	--show  (O op [eq1, eq2]) =  "(" ++ (show eq1) ++ op ++ (show eq2) ++ ")"     
	--show  (O op [eq])  = "("++op ++ show eq++")"
	--show  (O f xs) = f++"("++ printArrOfEq xs ++ ")"  
	show (O char) = show char
	show  (F "+" [eq1, eq2]) =  "(" ++ (show eq1) ++ ['+'] ++ (show eq2) ++ ")"     
	show  (F "-" [eq1, eq2]) =  "(" ++ (show eq1) ++ ['-'] ++ (show eq2) ++ ")"     
	show  (F "*" [eq1, eq2]) =  "(" ++ (show eq1) ++ ['*'] ++ (show eq2) ++ ")"     
	show  (F "/" [eq1, eq2]) =  "(" ++ (show eq1) ++ ['/'] ++ (show eq2) ++ ")"     
	show  (F "^" [eq1, eq2]) =  "(" ++ (show eq1) ++ ['^'] ++ (show eq2) ++ ")"     
	show  (F "-" [eq])  = "("++['-'] ++ show eq++")"
	show  (F f xs) = f++"("++ printArrOfEq xs ++ ")"  
--}	
printArrOfEq [a] = show a   
printArrOfEq (x:xs) = (show x) ++ ',': (printArrOfEq xs)

instance Eq Equation where 
	(C a)  == (C b)  = a==b
	(V a) ==  (V b) =  a==b
	(F f xs) == (F g ys) = and [(f == g), (xs == ys)] 
instance Num Equation where
        (+) (C a) (C b) = C (a+b)
        (+) a  b = F "+" [a,b]
        (-) (C a) (C b) = C (a-b)
        (-) a  b = F "-" [a,b]
        (*) (C a) (C b) = C (a*b)
        (*) a b = F "*"  [a,b]
--        fromInteger a = C a 
	
instance Fractional Equation where
	(/) (C a) (C b) = C (a/b)
	(/) a b = F "/" [a,b]
	
--        (/) (C a) (C b) = C (a/b)
--        (/) a  b = F "/" [a,b]





{-
| UniOp String Equation 
--| BinOp  String Equation Equation
-}
