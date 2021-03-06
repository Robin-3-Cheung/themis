#
# Copyright (c) 2015 Cossack Labs Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SOTER_SOURCES = $(wildcard $(SRC_PATH)/soter/*.c)
SOTER_HEADERS = $(wildcard $(SRC_PATH)/soter/*.h)
ED25519_SOURCES = $(wildcard $(SRC_PATH)/soter/ed25519/*.c)
ED25519_HEADERS = $(wildcard $(SRC_PATH)/soter/ed25519/*.h)

SOTER_SRC = $(SOTER_SOURCES) $(ED25519_SOURCES) $(CRYPTO_ENGINE_SOURCES)

SOTER_AUD_SRC += $(SOTER_SOURCES) $(ED25519_SOURCES) $(CRYPTO_ENGINE_SOURCES)
SOTER_AUD_SRC += $(SOTER_HEADERS) $(ED25519_HEADERS) $(CRYPTO_ENGINE_HEADERS)

# Ignore ed25519 during code reformatting as it is 3rd-party code (and it breaks clang-tidy)
SOTER_FMT_SRC += $(SOTER_SOURCES) $(CRYPTO_ENGINE_SOURCES)
SOTER_FMT_SRC += $(SOTER_HEADERS) $(CRYPTO_ENGINE_HEADERS)

include $(CRYPTO_ENGINE)/soter.mk

SOTER_OBJ = $(patsubst $(SRC_PATH)/%.c,$(OBJ_PATH)/%.o, $(SOTER_SRC))

SOTER_AUD = $(patsubst $(SRC_PATH)/%,$(AUD_PATH)/%, $(SOTER_AUD_SRC))

SOTER_FMT_FIXUP = $(patsubst $(SRC_PATH)/%,$(OBJ_PATH)/%.fmt_fixup,$(SOTER_FMT_SRC))
SOTER_FMT_CHECK = $(patsubst $(SRC_PATH)/%,$(OBJ_PATH)/%.fmt_check,$(SOTER_FMT_SRC))

SOTER_BIN = soter

soter_pkgconfig:
	@mkdir -p $(BIN_PATH)
	@sed -e "s!%prefix%!$(PREFIX)!" \
	     -e "s!%version%!$(VERSION)!" \
	     -e "s!%crypto-libs%!$(CRYPTO_ENGINE_LDFLAGS)!" \
	    $(SRC_PATH)/soter/libsoter.pc.in > $(BIN_PATH)/libsoter.pc
