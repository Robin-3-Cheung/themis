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

THEMISPP_TEST_SOURCES = $(wildcard $(TEST_SRC_PATH)/themispp/*.cpp)
THEMISPP_TEST_HEADERS = $(wildcard $(TEST_SRC_PATH)/themispp/*.hpp)

THEMISPP_TEST_OBJ = $(patsubst $(TEST_SRC_PATH)/%.cpp,$(TEST_OBJ_PATH)/%.opp,$(THEMISPP_TEST_SOURCES))

THEMISPP_TEST_FMT = $(THEMISPP_TEST_SOURCES) $(THEMISPP_TEST_HEADERS)

FMT_FIXUP += $(patsubst $(TEST_SRC_PATH)/%,$(TEST_OBJ_PATH)/%.fmt_fixup,$(THEMISPP_TEST_FMT))
FMT_CHECK += $(patsubst $(TEST_SRC_PATH)/%,$(TEST_OBJ_PATH)/%.fmt_check,$(THEMISPP_TEST_FMT))

clean_themispp_test:
	@rm -f $(THEMISPP_TEST_OBJ)
