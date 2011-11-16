import Text.PrettyPrint
import System.FilePath
import System.Environment
import System.Exit
import IO


main = do args <- getArgs
          prog <- getProgName
          case args of
               u:n:d:bs -> putStrLn . show $ repo u n d bs
               _        -> usage prog


repo url name descr bs = heading $+$ brs
     where heading = text "1." 
                     <+> repoUrl name <> char ':'
                     <+> text descr
           brs = vcat $ map maper bs
           maper = nest 5 . branch url name

repoUrl :: String -> Doc
repoUrl name = brackets n <> parens n
        where n = text name

branchUrl name br = brackets (text br) <> parens path
          where path = text $ combine name br

tarball :: String -> String -> Doc
tarball name branch = text "[tarball]" <> parens tb
        where tb = text (name </> branch <.> "tar.gz")

changes :: String -> String -> Doc
changes name branch = text "[CHANGES]" <> parens ch
        where ch = text $ name </> branch </> "CHANGES.txt"

anchor s = char '<'  <> text s <> char '>'

bullet s = char '*' <+> s
item   s = char '-' <+> s

branch url name br = bullet b $$ nest 5 body
       where b = branchUrl name br <+> u
             t = tarball name br
             c = changes name br
             u = parens $ text "URL=" <>
                        anchor (url </> name </> br)
             body = vcat [item t, item c]

usage prog = do hPutStrLn stderr $ unwords ["usage:", prog,
                                            "url name description",
                                            "branch [branches]"]
                exitFailure

