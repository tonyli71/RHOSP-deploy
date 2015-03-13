module Api
  module V2
    class InterfacesController < V2::BaseController

      include Api::Version2
      include Api::TaxonomyScope

      before_filter :find_resource, :only => [:show, :update, :destroy]
      before_filter :find_required_nested_object, :only => [:index, :show, :create]

      api :GET, '/hosts/:host_id/interfaces', 'List all interfaces for host'
      param :host_id, String, :required => true, :desc => 'id or name of host'

      def index
        @interfaces = @nested_obj.interfaces.paginate(paginate_options)
        @total = @nested_obj.interfaces.count
      end

      api :GET, '/hosts/:host_id/interfaces/:id', 'Show an interface for host'
      param :host_id, String, :required => true, :desc => 'id or name of nested host'
      param :id, String, :required => true, :desc => 'id or name of interface'

      def show
      end

      def_param_group :interface do
        param :interface, Hash, :action_aware => true, :desc => 'interface information' do
          param :mac, String, :required => true, :desc => 'MAC address of interface'
          param :ip, String, :required => true, :desc => 'IP address of interface'
          param :type, String, :required => true, :desc => N_("Interface type, e.g: Nic::BMC")
          param :name, String, :required => true, :desc => 'Interface name'
          param :subnet_id, Fixnum, :desc => 'Foreman subnet id of interface'
          param :domain_id, Fixnum, :desc => 'Foreman domain id of interface'
          param :username, String
          param :password, String
          param :provider, String, :desc => N_("Interface provider, e.g. IPMI")
          param :managed, :bool, :desc => N_("Should this interface be managed via DHCP and DNS smart proxy and should it be configured during provisioning?")
          param :virtual, :bool, :desc => N_("Alias or VLAN device")
          param :identifier, String, :desc => N_("Device identifier, e.g. eth0 or eth1.1")
          param :tag, String, :desc => N_("VLAN tag, this attribute has precedence over the subnet VLAN ID")
          param :attached_to, String, :desc => N_("Identifier of the interface to which this interface belongs, e.g. eth1")
          param :mode, String, :desc => N_("Bond mode of the interface, e.g. balance-rr")
          param :attached_devices, Array, :desc => N_("Identifiers of slave interfaces, e.g. ['eth1', 'eth2']")
          param :bond_options, String, :desc => N_("Space separated options, e.g. miimon=100")
        end
      end

      api :POST, '/hosts/:host_id/interfaces', 'Create an interface linked to a host'
      param :host_id, String, :required => true, :desc => 'id or name of host'
      param_group :interface, :as => :create

      def create
        interface = @nested_obj.interfaces.new(params[:interface], :without_protection => true)
        if interface.save
          render :json => interface, :status => 201
        else
          render :json => { :errors => interface.errors.full_messages }, :status => 422
        end
      end

      api :PUT, "/hosts/:host_id/interfaces/:id", "Update host interface"
      param :host_id, String, :required => true, :desc => 'id or name of host'
      param :id, :identifier, :required => true
      param_group :interface

      def update
        process_response @interface.update_attributes(params[:interface], :without_protection => true)
      end

      api :DELETE, "/hosts/:host_id/interfaces/:id", "Delete a host interface"
      param :id, String, :required => true, :desc => "id of interface"

      def destroy
        process_response @interface.destroy
      end

      private

      def allowed_nested_id
        %w(host_id)
      end

      def resource_class
        Nic::Base
      end
    end
  end
end
