import System.Environment
import System.FilePath
import Data.Char
import IO
import Data.List (intercalate)

url f ext = "./lectures" </> map mapper f <.> ext
         where mapper x | isSpace x = '-'
                        | otherwise =  x

alt i ln ext f = "[" ++ i ++ "]"
               ++ "("
               ++ url f ext
               ++  " \"" ++ ln ++ "\""
               ++  ")"

html t = alt t t "lhs.html"  t
pdf    = alt "pdf" "PDF" "lhs.pdf"
tex    = alt "latex" "LaTeX Source" "lhs.tex"
lhs    = alt "literate haskell" "Literate Haskell Source" "lhs"

main = do args <- getArgs
          prog <- getProgName
          if null args then usage prog
             else let title     = unwords args
                      setTitle  = flip ($) title
                      item      = html title
                      others    = intercalate "," $ map setTitle [pdf, tex, lhs]
                  in putStr (item ++ " \\[" ++ others ++ "\\]")

usage prog = hPutStrLn stderr $ unwords ["usage:" , prog, "Title"]