#
#   Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'utility'))

module Fog
  module Compute
    class Vsphere

      module Shared
        include Fog::Vsphere::Utility

        def get_ds_name_by_path(vmdk_path)
          path_elements = vmdk_path.split('[').tap { |ary| ary.shift }
          template_ds = path_elements.shift
          template_ds = template_ds.split(']')
          datastore_name = template_ds[0]
          datastore_name
        end

        def get_parent_dc_by_vm_mob(vm_mob_ref, options = {})
          mob_ref = vm_mob_ref.parent || vm_mob_ref.parentVApp
          while !(mob_ref.kind_of? RbVmomi::VIM::Datacenter)
            mob_ref = mob_ref.parent
          end
          mob_ref
        end

        def get_portgroups_by_dc_mob(dc_mob_ref)
          pg_name = {}
          portgroups = dc_mob_ref.network
          portgroups.each do |pg|
            pg_name[pg.name] = pg
          end
          pg_name
        end

      end

      class Real
        include Shared
      end

      class Mock
        include Shared
      end

    end
  end
end
