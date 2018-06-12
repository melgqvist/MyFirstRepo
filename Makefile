MODULE_NAME = IntegratorMigration
MB_INCLUDE  = $(CORE_SOLUTIONS)/4edi/include:$(CORE_ROOT)/4edi/include:$(CORE_ROOT)/config/attribute
MB_LIB      = $(CORE_SOLUTIONS)/4edi/lib:$(CORE_ROOT)/4edi/lib

MDEP_C4EDI = $(CORE_ROOT)/bin/c4edi 
MDEP_R4EDI = $(CORE_ROOT)/bin/r4edi 

MB_FLAGS = -T nopathtrace

INCLUDE = 	\
    -I $(CORE_SOLUTIONS)/config/attribute \
    -I $(CORE_ROOT)/config/attribute \
    -I src/4edi/include \
    -I $(MB_INCLUDE)

LIBRARIES = \
    -L src/4edi/lib \
    -L $(MB_LIB)

MB_FLAGS = -T -P nopathtrace
 
TARGETS = \
	target \
	target/4edi \
	target/4edi/component \
	target/4edi/pgm \
	target/4edi/component/procmbc_loadDML.x4  \
	target/4edi/component/procmbc_setmapattribute.x4  \
	target/4edi/pgm/testchannel.x4 \

compile: $(TARGETS)

target:	
	mkdir $@
target/4edi:
	mkdir $@
target/4edi/component:
	mkdir $@
target/4edi/pgm:
	mkdir $@

target/4edi/component/procmbc_loadDML.x4 : \
	src/4edi/lib/dml_channel.s4m                   \
	src/4edi/include/dml_channel.s4h           \
	src/4edi/component/procmbc_loadDML.s4
	$(MDEP_C4EDI)  $(MB_FLAGS)    \
	$(INCLUDE)                    \
  $(LIBRARIES)                  \
	-o $@                         \
	src/4edi/component/procmbc_loadDML.s4
	
target/4edi/component/procmbc_setmapattribute.x4 : \
	src/4edi/lib/dml_channel.s4m                   \
	src/4edi/include/dml_channel.s4h           \
	src/4edi/component/procmbc_setmapattribute.s4
	$(MDEP_C4EDI)  $(MB_FLAGS)    \
	$(INCLUDE)                    \
  $(LIBRARIES)                  \
	-o $@                         \
	src/4edi/component/procmbc_setmapattribute.s4
	
target/4edi/pgm/testchannel.x4 : \
	src/4edi/lib/dml_channel.s4m                   \
	src/4edi/include/dml_channel.s4h           \
	src/4edi/pgm/testchannel.s4
	$(MDEP_C4EDI)  $(MB_FLAGS)    \
	$(INCLUDE)                    \
	$(LIBRARIES)                    \
	-o $@                         \
	src/4edi/pgm/testchannel.s4	

distr:
	(cd target ; tar -cf - . | gzip) > $(MODULE_NAME).tgz
	
install:
	gzip -dc -S .tgz $(MODULE_NAME) | (cd $(B2BI_SHARED_LOCAL) ; tar -xf -)

clean:
	rm -rf $(TARGETS)
	
test:
	cp tests/DatabaseChannel $(B2BI_SHARED_LOCAL)/config
	$(MDEP_R4EDI) $(B2BI_SHARED_LOCAL)/4edi/pgm/testchannel.x4