module Eval where
import Root
import Diff
import Infix
import Sim
import Eqparser

--listv = [("x",45), ("y", 20), ("z", 30), ("w", 40)]--- this list will be given by parser
listf = []

-- enable user to enter angle in degree, currently using radians--------------
d2r a = (a*pi)/180
return1 a = Right a

--Calling Evaluater---------------------------------------------------------------
eval4 a listv = eval3 (Right a) listv

--Base Evaluator--------------------------------------------------------------------
eval3 :: Either t Equation -> [(String, Double)]-> Either String Equation

eval3 (Right (F "sin" [C a])) listv = Right $ C $ (sin.d2r) a
eval3 (Right (F "cos" [C a])) listv = Right $ C $ (cos.d2r) a
eval3 (Right (F "log" [C a])) listv | a<=0      = Left $ "Give only positive value for log"
			            | otherwise = Right $ C $ logBase 10 a
eval3 (Right (F "ln" [C a]))  listv | a<=0      = Left $ "Give only positive value for ln"
			            | otherwise = Right $ C $ logBase (exp 1) a
eval3 (Right (F "inv" [C a])) listv | a==0      = Left $ "Can't inverse zero"
                                    | otherwise = Right $ C $ 1/a

eval3 (Right (F "^" [C a, C b])) listv = Right $ C $ a**b

eval3 (Right (F "tan" [C a]))   listv | a==90     = Left $ "Infinite"
                        	      | otherwise = Right $ C $ (tan.d2r) a
eval3 (Right (F "cosec" [C a])) listv | a==0      = Left $ "Infinite"
                        	      | otherwise = Right $ C $ 1/(sin.d2r) a
eval3 (Right (F "sec" [C a]))   listv | a==0      = Left $ "Infinite"
                        	      | otherwise = Right $ C $ 1/(cos.d2r) a
eval3 (Right (F "cot" [C a]))   listv | a==0      = Left $ "Infinite"
                        	      | otherwise =  Right $ C $ 1/(tan.d2r) a

eval3 (Right (F "sinh" [C a])) listv = Right $ C $ (sinh.d2r) a
eval3 (Right (F "cosh" [C a])) listv = Right $ C $ (cosh.d2r) a
eval3 (Right (F "tanh" [C a])) listv = Right $ C $ (tanh.d2r) a
eval3 (Right (F "+" [C a, C b] )) listv =  Right $ C $ a+b
eval3 (Right (F "-" [C a, C b] )) listv =  Right $ C $ a-b
eval3 (Right (F "*" [C a, C b] )) listv =  Right $ C $ a*b
eval3 (Right (F "/" [C a, C b])) listv | b==0      =  Left $ "Divide by zero error"
                        	       | otherwise =  Right $ C $ a / b

eval3 (Right (C a)) listv = Right $ C a

--Variable sustitution----------------------------------------------------------------
eval3 (Right (V x)) listv = Right (C $ sub x listv)
eval3 (Right (F "sin" [V a])) listv = eval3 (Right (F "sin" [C $ sub a listv])) listv
eval3 (Right (F "cos" [V a])) listv = eval3 (Right (F "cos" [C $ sub a listv])) listv
eval3 (Right (F "tan" [V a])) listv = eval3 (Right (F "tan" [C $ sub a listv])) listv
eval3 (Right (F "sinh" [V a])) listv = eval3 (Right (F "sinh" [C $ sub a listv])) listv
eval3 (Right (F "cosec" [V a])) listv = eval3 (Right (F "cosec" [C $ sub a listv])) listv
eval3 (Right (F "sec" [V a])) listv = eval3 (Right (F "sec" [C $ sub a listv])) listv
eval3 (Right (F "cosh" [V a])) listv = eval3 (Right (F "cosh" [C $ sub a listv])) listv
eval3 (Right (F "tanh" [V a])) listv = eval3 (Right (F "tanh" [C $ sub a listv])) listv
eval3 (Right (F "inv" [V a])) listv = eval3 (Right (F "inv" [C $ sub a listv])) listv
eval3 (Right (F "cot" [V a])) listv = eval3 (Right (F "cot" [C $ sub a listv])) listv
eval3 (Right (F "log" [V a])) listv = eval3 (Right (F "log" [C $ sub a listv])) listv
eval3 (Right (F "ln" [V a])) listv = eval3 (Right (F "ln" [C $ sub a listv])) listv
eval3 (Right (F "^" [V a, V b])) listv = eval3 (Right (F "^" [C $ sub a listv, C $ sub a listv])) listv
eval3 (Right (F "^" [V a, C b])) listv = eval3 (Right (F "^" [C $ sub a listv, C b])) listv
eval3 (Right (F "+" [V a, V b])) listv = eval3 (Right (F "+" [C $ sub a listv, C $ sub b listv])) listv
eval3 (Right (F "-" [V a, V b])) listv = eval3 (Right (F "-" [C $ sub a listv, C $ sub b listv])) listv
eval3 (Right (F "*" [V a, V b])) listv = eval3 (Right (F "*" [C $ sub a listv, C $ sub b listv])) listv
eval3 (Right (F "/" [V a, V b])) listv = eval3 (Right (F "/" [C $ sub a listv, C $ sub b listv])) listv
eval3 (Right (F "+" [V a, C b])) listv = eval3 (Right (F "+" [C $ sub a listv, C b])) listv
eval3 (Right (F "-" [V a, C b])) listv = eval3 (Right (F "-" [C $ sub a listv, C b])) listv
eval3 (Right (F "*" [V a, C b])) listv = eval3 (Right (F "*" [C $ sub a listv, C b])) listv
eval3 (Right (F "/" [V a, C b])) listv = eval3 (Right (F "/" [C $ sub a listv, C b])) listv
eval3 (Right (F "+" [C a, V b])) listv = eval3 (Right (F "+" [C a, C $ sub b listv])) listv
eval3 (Right (F "-" [C a, V b])) listv = eval3 (Right (F "-" [C a, C $ sub b listv])) listv
eval3 (Right (F "*" [C a, V b])) listv = eval3 (Right (F "*" [C a, C $ sub b listv])) listv
eval3 (Right (F "/" [C a, V b])) listv = eval3 (Right (F "/" [C a, C $ sub b listv])) listv


--Recursive Evaluation-----------------------------------------------------------------------------
eval3 (Right (F f xs )) listv  | checkState1 xs listv = eval3  (Right (F f $ evalr1 xs listv)) listv
                               | otherwise     = joinErrors1 xs listv

evalr1 xs listv = fmap unreturn $ fmap ((\x -> eval3 x listv) .return1) xs 
checkState1 xs listv = and  $ fmap (isRight.(\x -> eval3 x listv).return1) xs
joinErrors1 xs listv = Left $ joinIt $ fmap ((\x -> eval3 x listv).return1) xs


--eval3 _ _ = Left $ "Error in input"

--Set of useful functions to extract data from containers-----------------------------------------
unreturn (Right a) = a
isRight (Right _) = True
isRight (Left _) = False
get (Left a) = a++" ,"
get _ = ""
extract:: Equation-> Double
extract (C a) = a
joinIt (x:xs) = (get x) ++ (joinIt xs)
joinIt _ = ""

--substitute-------------------------------------------------
sub x listv = snd(search listv x)
search (x1:xs) x = if (fst x1 == x) then x1
                   else (search xs x)

-------------------NR Method--------------------------------------------------------------------

-- getvar will return variable used in a
getvar :: Equation -> String
getvar (V x) = x
getvar (F f [V a]) = a
getvar (F f [C a]) = "Error"
getvar (F f [V x,V y]) = x
getvar (F f (x:xs)) | getvar x == "Error" = head $ fmap getvar xs
                    | otherwise           = getvar x
getvar _ = "Error"


find :: Equation->Double->Double
find a x0 = (x0 - (getf a x0/getfDash a x0))

getf :: Equation->Double->Double
getf a x0 = (extract.unreturn)(eval4 (substitute a (V $ getvar a) $ C x0) listf)
getfDash :: Equation->Double->Double
getfDash a x0 = (extract.unreturn)(eval4 (substitute (diff a (V $ getvar a)) (V $ getvar a)  $ C x0) listf)
-- Find the convergence rate------------------
converge :: Equation->Double->Double
converge a x0 = ((( abs(x0 -  (find a x0))) / x0) * 100)

--Solving with NR method----------------------
solve :: Equation->Double->Double
--solve a x0 = if ((converge a x0)  > 0.0005) then solve a (find a x0)
  --           else (find a x0)
solve a x0  | (converge a x0)  > 0.000005  = solve a (find a x0)
            | otherwise                  = find a x0

----------------- Call Parser -------------------------------------


result::Either String Container-> Either String Double
result s | isRight s  =  (exec.unreturn) s
         | otherwise  =  Left $ get s

resultPretty :: Either String Double -> String
resultPretty (Right val) = show val
resultPretty (Left val) =  val

resultOutput = resultPretty . result 

exec (Solve a) = Right $ solve a 2
exec (Eval a xs) = if (null xs) then pass2 a listf
                   else pass4 a xs

pass2 a  listf  | isRight $ eval4 a listf  =  Right $ (extract.unreturn) $ eval4 a listf
                | otherwise            =  Left  $ get $ eval4 a listf
pass4 a xs | isRight $ eval4 a xs =  Right $ (extract.unreturn) $ eval4 a xs
           | otherwise            =  Left  $ get $ eval4 a xs
