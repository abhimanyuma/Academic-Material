module Eqparser where
import Monad
import System.Environment
import Text.ParserCombinators.Parsec
import Root

functionlist = [("sin",1),("cos",1),("sinh",1),("tan",1),("sec",1),("cosec",1),("log",1),("ln",1),("cot",1),("cosh",1),("tanh",1),("diff",2),("pi",0),("e",0)];

functionname = map fst functionlist      
{-

checkfull:: (Either String Equation) -> (Either String Equation)
check val@(Left _)          = val
check term@(Right equation) = check Right 

check::Equation-> (Either String Equation)
check term@(C _)                 = Right term
check term@(V _)                 = Right term     
check term@(F "diff" [func,(V _)])     = ifreturn (Right term) $ check func
check term@(Right (F "diff" _)         = Left "Diffrentiation requires single variable as second argument"

check term@(Right (F func list)       | func 'elem' ["+","-","/","*","^"]                                       = ifreturn term $ checklist list
                                      | func 'elem' functionname  && (func,(length list)) 'elem' functionlist   = ifreturn term $ checklist list
                                      | func 'elem' functionname  && ! (func,(length list)) 'elem' functionlist = Left "Wrong parameter count for " ++ func 
                                      | Otherwise                                                               = Left "Unknown Function " ++ func ++" Passed"

checklist :: [Equation] -> Either String Bool

--}
                                                 


operator :: Parser Char
operator = oneOf "=+-*/^"
funcOperator :: Parser Char
funcOperator = oneOf "(),"
parantheses :: Parser Char
parantheses = oneOf "()"

skipWhite :: Parser ()
skipWhite = skipMany1 space


removeWhite::String->String
removeWhite [] = []
removeWhite (' ':rest) = removeWhite rest
removeWhite(ch:rest)  = ch:removeWhite rest
                            

parseTotal :: String -> Either ParseError [Equation]
parseTotal input = parse parseExpr "Madskell :" $ removeWhite input 
--                           Left err -> "Not parsed: " ++ show err
--                           Right val -> "Found value :" ++ show val
parseString :: Parser String
parseString = do first <- letter 
                 rest  <- many (letter <|> digit)
                 let name=[first] ++ rest
                 return $ name

parseInteger :: Parser [Equation]
--parseInteger = [liftM (C . read) $ many1 digit]
parseInteger = do num <- many1 digit
                  let value = (read num)
                  return $[ C value]


parseFloat :: Parser [Equation] 
parseFloat = do lhs <- many1 digit
                dot <-  char '.' 
                rhs <-  many1 digit
                let num = lhs ++ [dot] ++ rhs
                let value = (read num)
                return $[ C value]

parseNumber :: Parser [Equation]
parseNumber = (try parseFloat) <|> parseInteger



parseOperator :: Parser Equation
parseOperator = do x <- operator
                   return $ O x

parseLeft :: Parser Equation
parseLeft = do x <- char '('
               return $ O x
 
parseRight:: Parser Equation
parseRight = do x <- char ')'
                return $ O x

parseFunctionList :: Parser [Equation]
parseFunctionList = do list <- sepBy parseExpr $ char ','
                       return $ map consolidate $ map inToPre list


parseFunction :: Parser [Equation]
parseFunction = do f <- parseString
                   char '('
                   arg <- parseFunctionList
                   char ')'
                   return $[ F f arg]

parseVariable :: Parser [Equation] 
parseVariable = do v <- parseString
                   return $[V v]

parseFuncVariable :: Parser [Equation]
parseFuncVariable = (try parseFunction) <|> parseVariable

--parseTerm::Parse [Equation]
--parseTerm=many (parseFuncVariable<|>parseNumber<|>parseOperator)


parseExprSingle :: Parser [Equation]
parseExprSingle  =   parseFuncVariable
                 <|> parseNumber
                 <|> parseBracketed
 

parseExpr :: Parser [Equation]
--{parseExpr = do exprList <- many1 parseExprSingle
--               return exprList--}
parseExpr =  do expr1 <- parseExprSingle
                try (do oper <- parseOperator
                        rest <- parseExpr
                        return (expr1++[oper]++rest) )
                 <|> return expr1

parseBracketed :: Parser [Equation]
parseBracketed = do left <- parseLeft
                    expr <- parseExpr
                    right <-parseRight
                    return ([left]++expr++[right])
{--
parseTerm::Parser [Equation]
parseTerm = parseBracketed 
            <|> parseExpr
            
             
--}
                          
infixToPostfix::Either ParseError [Equation]-> Either ParseError [Equation]
infixToPostfix (Right eqlist)= Right (infixToPostfixStacked [O '('] $ eqlist++[O ')'])
infixToPostfix val@(Left _) = val

inToPre ::[Equation] -> [Equation]
inToPre eqlist = infixToPostfixStacked [O '('] $ eqlist++[O ')']

infixToPostfixStacked [] [] = []

infixToPostfixStacked stack ((term@(F _ _)):rest)    = term:(infixToPostfixStacked stack rest)

infixToPostfixStacked stack ((term@(V _ )):rest)     = term:(infixToPostfixStacked stack rest)

infixToPostfixStacked stack ((term@(C _ )):rest)     = term:(infixToPostfixStacked stack rest)

infixToPostfixStacked stk@((O top):stack) equation @(term@(O operator ):rest)  |(operator == ')' && top =='(') = infixToPostfixStacked stack rest
                                                                               | operator == ')'              = (O top):(infixToPostfixStacked stack equation)
                                                                               | operator == '('              = infixToPostfixStacked (term:stk) rest
                                                                               | top == '('                   = infixToPostfixStacked (term:stk) rest
                                                                               | prec(operator) > prec(top)   = infixToPostfixStacked (term:stk) rest 
                                                                               | prec(operator) <= prec(top)  = (O top):(infixToPostfixStacked stack equation)


prec '+' = 10
prec '-' = 10
prec '=' = 0
prec '*' = 15
prec '/' = 15
prec '^' = 20

consolidateError::Either ParseError [Equation] -> Either ParseError Equation
consolidateError (Right term) = Right (consolidate term)
consolidateError (Left val)   = Left val 

consolidate::[Equation]->Equation
consolidate=consolidateStack [] 

consolidateStack [a] [] = a

consolidateStack stack ((term@(F _ _)):rest)  = consolidateStack  (term:stack) rest 
 
consolidateStack stack ((term@(C _  )):rest)  = consolidateStack  (term:stack) rest 

consolidateStack stack ((term@(V _  )):rest)  = consolidateStack  (term:stack) rest 

consolidateStack (a:b:stack) ((term@(O operator)):rest) = consolidateStack (combined:stack) rest 
                                                           where combined = (F [operator] [b,a])



parseSolve:: Parser String
parseSolve=string "Solve"

parseEvaluate:: Parser String
parseEvaluate= string "Evaluate"

parseAt:: Parser String
parseAt = (try $ string "At") <|> string ""
 


parseSolver::Parser Container
parseSolver = do parseSolve
                 x <- parseExpr
                 let y = consolidate $ inToPre x
                 return (Solve y)

parseEvaluater::Parser Container
parseEvaluater= do parseEvaluate
                   char '('
                   x <- parseExpr
                   let y = consolidate $ inToPre x
                   char ')'
                   parseAt
                   b <- sepBy parseBinding  $ char ',' 
                   return (Eval y b)

parseCont:: Parser Container
parseCont = (try parseSolver) <|> parseEvaluater                                     

parseBinding::Parser Binding
parseBinding = do v<-parseString
                  char '='
                  n<-parseNum
                  return (v,n)
parseNum::Parser Double
parseNum = (try parseDouble) <|> parseInt


parseInt :: Parser Double
parseInt= do lhs <- many1 digit
             let value = (read lhs)
             return value 
                
parseDouble :: Parser Double
parseDouble= do lhs <- many1 digit
                dot <-  char '.'
                rhs <-  many1 digit
                let num = lhs ++ [dot] ++ rhs
                let value = (read num)
                return value 
             

parseEquation :: String -> Either String Equation
parseEquation string = case (consolidateError $ infixToPostfix $ parseTotal string) of
                            Right val -> Right val
                            Left err  -> Left ("Compiler Error: \n" ++ show err)

parseContainer::String -> Either String Container
parseContainer string = case parse parseCont "Madskell:"  $ removeWhite string of
                             Right val -> Right val
                             Left err -> Left ("Compiler Error :\n" ++ show err)

