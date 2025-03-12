#linux
# VIVADO_CMD := srun -p lite vivado -mode batch -source
#window
VIVADO_CMD := vivado -mode batch -source
BRANCH := main
LATEST_COMMIT := $(shell git ls-remote origin $(BRANCH) | awk '{print $$1}')
LOCAL_COMMIT := $(shell git rev-parse HEAD)
UNCOMMITTED_CHANGES := $(shell git status --porcelain)

.PHONY: all check update merge axi_lite_gen rollback clean report

all: check update axi_lite_gen


check:
	@echo "Checking repository status..."
	@git fetch origin $(BRANCH)
	@if [ "$(LOCAL_COMMIT)" = "$(LATEST_COMMIT)" ]; then \
		echo "Repository is up to date."; \
	else \
		echo "Repository is out of date."; \
	fi

update:
	@if [ "$(LOCAL_COMMIT)" != "$(LATEST_COMMIT)" ]; then \
		echo "WARNING: Your local branch is out of date."; \
		if [ -n "$(UNCOMMITTED_CHANGES)" ]; then \
			echo "You have uncommitted local changes."; \
			echo "Options:"; \
			echo "  1. Stash changes: Run 'git stash' before updating."; \
			echo "  2. Merge changes: Run 'make merge'."; \
			echo "  3. Force reset (lose changes): Type 'reset'."; \
			read choice; \
			if [ "$$choice" = "reset" ]; then \
				echo "This will discard all local changes!(y/n)"; \
				read confirm; \
				if [ "$$confirm" = "y" ]; then \
					git reset --hard origin/$(BRANCH); \
				else \
					echo "Reset canceled."; \
					exit 1; \
				fi; \
			else \
				echo "Update canceled. Please resolve unsaved changes."; \
				exit 1; \
			fi; \
		else \
			echo "Fetching latest changes..."; \
			git reset --hard origin/$(BRANCH); \
		fi \
	else \
		echo "Already at the latest commit."; \
	fi

merge:
	@if [ -n "$(UNCOMMITTED_CHANGES)" ]; then \
		echo "You have uncommitted changes. Commit them before merging."; \
		git status; \
		echo "Enter commit message: "; \
		read msg; \
		git add ./; \
		git commit -m "$$msg"; \
	fi
	@echo "Merging latest changes from remote..."
	@git pull origin $(BRANCH) --no-rebase

push:
	@git status
	@git add ./
	@git commit -m "ibert_test"
	@git push origin $(BRANCH) 

sgbus_ibert:
	@echo "Running sgbus axi lite master transactor stub generation script on Slurm..."
	@$(VIVADO_CMD) sgbus_ibert_gen.tcl

rollback:
	@echo "Enter commit hash to rollback to:"
	@read commit_hash; \
	echo "WARNING: This will reset the repository to $$commit_hash! All uncommitted changes will be lost."; \
	echo "Do you want to continue? (yes/no)"; \
	read confirm; \
	if [ "$$confirm" = "yes" ]; then \
		git reset --hard $$commit_hash; \
		echo "Rolled back to $$commit_hash"; \
	else \
		echo "Rollback canceled."; \
	fi

clean:
	@echo "Cleaning up Vivado-generated files..."
	rm -rf .Xil *.jou *.log *.str *.cache *.hw *.runs *.sim *.gen *.xpr vivado_project/

report:
	@echo "Repository Status:"
	@git status
	@echo "Latest Remote Commit: $(LATEST_COMMIT)"
	@echo "Current Local Commit: $(LOCAL_COMMIT)"
	@echo "Branch: $(BRANCH)"
