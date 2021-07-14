[ -d ~/protected ] || mkdir ~/protected
[ -d ~/protected/projects ] || mkdir ~/protected/projects

function clone() {
   repo="$1"
   dest="$2"
   symlink="$3"

   if ! [ -d "$dest" ]; then
	mkdir -p "$dest"
	git clone --recurse-submodules "$repo" "$dest"/.
	if ! [ -z "$symlink" ]; then
		ln -s "$dest" "$symlink"
	fi
   fi
}

clone  "git@github.com:neuhalje/xpra-work-environ-docker.git" ~/protected/projects/xpra-work-environ-docker

export R_LIBS_USER="~/R-libs"
echo "R_LIBS_USER=${R_LIBS_USER}" > ~/.Renviron

if [[ ! $(grep -s -F R_LIBS_USER ~/.profile) ]]; then 
	echo "R_LIBS_USER=${R_LIBS_USER}" >> ~/.profile
fi


echo '
 dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)

 install.packages("utf8", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("ascii", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("dplyr", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("ggthemes", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("ggplot2", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("ggalluvial", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("tidyverse", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
 install.packages("pivottabler", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")

update.packages(ask = FALSE, lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")
' | R --no-save


