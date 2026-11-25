## This is emCode

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -ic "vmt"

## -include makestuff/perl.def

######################################################################

Sources += Makefile .gitignore LICENSE.txt README.md

######################################################################

## zdoi:
release: v1.0.rrelease

## Indicator for _current_ code repo for the emergent heterogeneity manuscript
Sources += kappa.tag

######################################################################

Ignore += $(wildcard *.pdf)

## This rule will take days to run in a new repo
all: CohortPlot.Rout.final lsFig.Rout.final rcHist.Rout.final TimeEvolutionStack.Rout.final

targets: CohortPlot.Rout.pdf lsFig.Rout.pdf rcHist.Rout.pdf TimeEvolutionStack.Rout.pdf

## Grand scripts
## targets.pipeR.sh:
## targets.final.pipeR.sh:

## Try to make a map
## targets.final.dd.mf.mg.pdf:

######################################################################

Sources += $(wildcard *.R)
Sources += $(wildcard slow/*)
Sources += $(wildcard *.pipeR.sh pipeWrap/*.R pipeWrap/*/*.R)
autopipeR = defined

CohortPlot.Rout: CohortPlot.R plotStyle.R slow/CohortSim.rda params.rda
slowtarget/CohortSim.Rout: CohortSim.R params.rda funs.rda
	$(pipeR)

lsFig.Rout: lsFig.R lsCurves.rds lsDensity.rds
	$(pipeR)
lsDensity.Rout: lsDensity.R realAct.rda
lsCurves.Rout: lsCurves.R params.rda funs.rda
realAct.Rout: realAct.R params.rda funs.rda

RcAverage.Rout: RcAverage.R  rcHist.rds
	$(pipeR)
rcHist.Rout: slow/IBM_for_histSim.rda params.rda
slowtarget/IBM_for_histSim.Rout: IBM_for_histSim.R IBM_for_hist.rda params.rda
	$(pipeR)

TimeEvolutionStack.Rout: TimeEvolutionStack.R plotStyle.R stackbar.rds  slow/TimeEvolutionSim.rda   params.rda funs.rda
slowtarget/TimeEvolutionSim.Rout: TimeEvolutionSim.R  params.rda funs.rda
	$(pipeR)

stackbar.Rout: stackbar.R params.rda  slow/stackbarSim.rda
slowtarget/stackbarSim.Rout: stackbarSim.R params.rda funs.rda
	$(pipeR)

######################################################################

collaborators: tapangoel1994.invite mikeroswell.invite Aznlfr.invite sjbeckett.invite

######################################################################

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Ignore += makestuff*.stamp
Makefile: makestuff01.stamp
makestuff%.stamp: | makestuff
	- $(RM) makestuff*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/slowtarget.mk
-include makestuff/makegraph.mk

-include makestuff/git.mk
-include makestuff/visual.mk
