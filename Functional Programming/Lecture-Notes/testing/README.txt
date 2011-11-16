# Configuring

Set the following variables in Makefile.configure

    * SOURCE : path to the source.
    * DESTINATION: location of your actual homepage (an rsync url).

The directory pointed by the SOURCE variable should contain a Makefile
with the following rules.

   * make -C ${SOURCE} all should build all the required html files,

   * make -C ${SOURCE} clean should clean up the files,

   * make -C ${SOURCE} .file should create a file ${SOURCE}/.files
     which contains those files that have to be transferred to the
     ${DESTINATION}.

One way to set up such a directory is to use a set of default rules
that are available with this package. See the next section for
details.

you can then manage the homepage with the following commands.

   * make all : build the homepage at ${SOURCE}.

   * make update: build the homepage at ${SOURCE} and update at ${DESTINATION}
          using rsync.

   * make update-dryrun: build the homepage at ${SOURCE} and only dry run the
          update procedure. Useful to check what is transferred.

# Variables exported by the main makefile.

As mentioned the source directory, which is where actual contents
reside, should have a Makefile of its own. The following environment
variables are passed on to it.

    * SOURCE: The source path.

    * DESTINATION: The destination rsync url.

    * BASE_URL: The base url of the homepage.

    * DIR: The relative path to the directory you are in. If you are
      at your document root then it is empty.
    
    * DEFAULT_RULES: This is the absolute path to the Makefile which
      contain defaults to some common targets. See next section for
      details.

    * SCRIPTS: The directory that contains helper scripts.

    * MACROS: The director that contains the helper m4 macros.

    * TEMPLATES: The directory that contains all the pandoc templates.
      The structure of the directory will be
~~~~~~~~~~~~~~~~~~
      template
      template/latex   # All the latex templates
      template/html    # The html templates etc
      ...
~~~~~~~~~~~~~~~~~~~~~

# Default actions:

Some make file rules that we found common in may directories are
provided in the file default/Makefile. The main Makefile exports the
variable DEFAULT_RULES which can be included in the sub makes to get
access to these rules.

To use this default rules one needs to define the following variables.

1. SUBDIRS: The subdirectories of this directory where stuff resides.

2. HTML: The html files of interest

3. FILES: The actual files that have to be sent to the homepage.  This
   is actually optional as by default it is set to HTML. If there are
   other materials that are not generated but set, like for example
   pdf files or image files, explicitly set this variable.

In case the current directory hosts a DARCS repo, set the variable

4. DARCS_REPO: base directory of darcs repository

5. DARCS_BRANCHES: The branches of the repository to be published.

Darcs branches are darcs repositories themselves. We assume that the
branches are subdirectories of ${DARCS_REPO}. For example, let us say
one has the branches stable, testing and unstable of the repository
foo.  Then, the braches are located at foo/stable foo/testing and
foo/unstable respectively.

6. LITERATE_HASKELL: The literate haskell files that we want to
   publish from here. If this variable lists say a file `foo.lhs` then
   we will generate the following

   - `foo.lhs`	: the actual code it self.
   - `foo.lhs.html`: The html version of the code
   - `foo.lhs.tex`: The latex version of the code
   - `foo.lhs.pdf`:  The pdf version of the code

Besides you may set the variables.

1. M4: The m4 command with necessary command line arguments.

2. PANDOC: The pandoc converter.

The default rules are available by including the file pointed by the
variable DEFAULT_RULES. They also take care of exporting the important
variables to the sub makes.

A typical make file will look like

HTML=index.html
SUBDIRS=foo bar

include ${DEFAULT_RULES}

all: default-all
clean: default-clean
