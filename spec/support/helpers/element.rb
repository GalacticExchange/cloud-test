module Element
  REGISTRATION_FORM = 'form#new_user'
  LOG_IN_BUTTON = '[data-btn="login"]'
  SIGN_UP_LINK = '[data-link="sign-up"]'
  SIGN_UP_BUTTON = '[data-btn="sign-up"]'
  SIGN_IN_BUTTON = '[data-btn="sign-in"]'
  AVATAR_ICON = '#avatar_btn'
  AVATAR_ICON_DD_MENU = '[data-div="avatar-drop"]'

  ON_PREMISE_CARD = '[data-div="on-premise-card"]'
  AWS_CARD = '[data-div="aws-card"]'
  CREATE_ON_PREMISE_BTN = '[data-btn="on-premise-btn"]'
  CREATE_AWS_BTN = '[data-btn="aws-btn"]'
  CREATE_ON_PREMISE_CLUSTER_BTN = '[data-btn="create-onprem"]'
  CREATE_AWS_CLUSTER_BTN = '[data-btn="create-aws"]'
  KEY_ID = 'PH_GEX_KEY_ID'
  ACCESS_KEY = 'PH_GEX_ACESS_KEY'

  SIGN_OUT_BUTTON = '[data-btn="sign-out"]'
  SIGN_OUT_MESSAGE = '[data-block="flash-msg"]'

  LOGOTYPE = '[data-div="logo"]'

  MAIN_MENU = '[data-block="main_menu"]'
  NODES_TAB = '[data-div="nodes-tab"]'
  STATISTICS_TAB = '[data-div="stats-tab"]'
  APP_HUB_TAB = '[data-div="apphub-tab"]'
  INSTALLED_APPS_TAB = '[data-div="installed-apps-tab"]'

  ADD_LOCAL_NODE_BUTTON = '[data-btn="add-node"]'

  OK_BUTTON = 'div[data-btn="popup-ok-btn"]'
  YES_BUTTON = '[data-btn="popup-yes-btn"]'

  NODES_LIST = '#list-nodes'
  LOCAL_NODE = '[data-text="local-node"]'
  NODE_STATE = '[data-div="node-state"]'
  STATUS_CHECKS = '[data-div="node-checks"]'

  SETTINGS_NODE_BUTTON = '[data-btn="node-settings-btn"]'
  SETTINGS_APP_BUTTON = '[data-btn="settings-btn"]'

  UNINSTALL_BUTTON = '[data-btn="uninstall-node"]'
  REINSTALL_BUTTON = '[data-btn="reinstall-node"]'
  REMOVE_BUTTON = '[data-btn="remove-node"]'
  FORCE_UNINSTALL_BUTTON = '[ng-click="uninstallNodeForce()"]'
  UNINSTALL_APP_BUTTON = '[data-btn="uninstall-app"]'

  STOP_BUTTON = '[data-btn="stop-node"]'
  START_BUTTON = '[data-btn="start-node"]'
  RESTART_BUTTON = '[data-btn="restart-node"]'

  DATAMEER_CARD = '#datameer_card'
  ROCANA_CARD = '#rocana_card'
  ZOOMDATA_CARD = '#zoomdata_card'
  INSTALL_LINK = '[data-btn="install"]'
  OPEN_LINK = '[data-btn="open"]'

  CONFIG_TOP = '#install_config_top'
  CONTINUE_BUTTON = '[ng-click="submit()"]'

  APP_STATE = '[data-div="app-state"]'

  SERVICE_BLOCK= '[data-div="services-list"]'
  WEB_UI_BLOCK = '#webui_block'
  PUBLIC_IP = '#webui_public_ip'
  PORT = '#webui_port'

  def registration_form
    find('form#new_user')
  end

   def login_button
     find('[data-btn="login"]')
   end
  def sign_up_link
    find('[data-link="sign-up"]')
  end

  def sign_up_button
    find('[data-btn="sign-up"]')
  end

  def sign_in_button
    find('[data-btn="sign-in"]')
  end

  def avatar_icon
    find('#avatar_drop')
  end

  def on_premise_card
    find('[data-div="on-premise-card"]')
  end
  def aws_card
    find('[data-div="aws-card"]')
  end

  ####
=begin
  def method_missing(method, *args, &block)
    if method.to_s =~ /^find_(.*)$/
      const = self.class.const_get($1.upcase)
      send(:find, const)
    else
      super
    end

  end
=end

  ####
  def create_on_premise_button
    on_premise_card.find('[data-btn="on-premise-btn"]')
  end

  def create_aws_button
    aws_card.find('[data-btn="aws-btn"]')
  end

  def create_on_premise_cluster_btn
    find('[data-btn="create-onprem"]')
  end

  def create_aws_cluster_btn
    find('[data-btn="create-aws"]')
  end

  def sign_out_button
    find('[data-btn="sign-out"]')
  end

  def sign_out_message
    find('[data-block="flash-msg"]').text
  end

  def logotype
    find('[data-div="logo"]')
  end
  def main_menu
    find('[data-block="main_menu"]')
  end

  def nodes_tab
    main_menu.find('[data-div="nodes-tab"]')
  end

  def stats_tab
    main_menu.find('[data-div="stats-tab"]')
  end

  def app_hub_tab
    main_menu.find('[data-div="apphub-tab"]')
  end

  def installed_apps_tab
    main_menu.find('[data-div="installed-apps-tab"]')
  end

  def add_local_node_btn
    find(ADD_LOCAL_NODE_BUTTON, :text => 'Add local node')
  end

  def add_aws_node_btn
    find(ADD_LOCAL_NODE_BUTTON, :text => 'Add AWS node')
  end

  def add_nodes_btn
    find('button', :text => 'Add nodes')
  end
  def main_window
    page.driver.browser.window_handles.first
  end

  def pop_up
    page.driver.browser.window_handles.last
  end

  def ok_button
    find(OK_BUTTON)
  end
  def yes_button
    find(YES_BUTTON)
  end

  def node_list
    find(NODES_LIST)
  end

  def local_node
    NODES_LIST.find(LOCAL_NODE, :text => '(local)')
  end

  def node_state
    first(NODE_STATE).text
  end
  def status_checks
    first(STATUS_CHECKS).text
  end

  def settings_app_button
    find(SETTINGS_APP_BUTTON)
  end

  def settings_node_button
    find(SETTINGS_NODE_BUTTON)
  end

  def uninstall_button
    find(UNINSTALL_BUTTON)
  end

  def uninstall_app_button
    find(UNINSTALL_APP_BUTTON)
  end

  def reinstall_button
    find(REINSTALL_BUTTON)
  end
  def remove_button
    find(REMOVE_BUTTON)
  end

  def force_uninstall_button
    find(FORCE_UNINSTALL_BUTTON)
  end

  def stop_button
    find(STOP_BUTTON)
  end

  def start_button
    find(START_BUTTON)
  end

  def restart_button
    find(RESTART_BUTTON)
  end

  def datameer_card
    find(DATAMEER_CARD)
  end
  def rocana_card
    find(ROCANA_CARD)
  end
  def zoomdata_card
    find(ZOOMDATA_CARD)
  end

  def datameer_install_link
    datameer_card.find(INSTALL_LINK)
  end

  def datameer_open_link
    datameer_card.find(OPEN_LINK)
  end

  def rocana_install_link
    rocana_card.find(INSTALL_LINK)
  end

  def zoomdata_install_link
    zoomdata_card.find(INSTALL_LINK)
  end

  def zoomdata_open_link
    zoomdata_card.find(OPEN_LINK)
  end
  def rocana_open_link
    rocana_card.find(OPEN_LINK)
  end

  def config_top
    find(CONFIG_TOP)
  end
  def top_continue_button
    config_top.find(CONTINUE_BUTTON)
  end

  def app_state
    find(APP_STATE).text
  end

  def service_block
    find(SERVICE_BLOCK)
  end

  def web_ui_block
    service_block.find(WEB_UI_BLOCK)
  end

  def app_public_ip
    public_ip = web_ui_block.find(PUBLIC_IP).text
    public_ip
    puts public_ip
  end

  def app_port
    port = web_ui_block.find(PORT).text
    port
    puts port
  end
  def fill_config_form_for_aws
    config_form = find('.simple-form')
    region = config_form.find('[name="aws-region"]').click
    us_west_2 = find('[label="US West (Oregon - us-west-2)"]').click
    key_id = config_form.find('[ng-model="aws_cluster.awsKeyId"]')
    key_id.set(KEY_ID)
    access_key = config_form.find('[ng-model="aws_cluster.awsKeySecret"]')
    access_key.set(ACCESS_KEY)
  end

  def go_to_clusters_page
    cluster_dd_block = find('#cluster_actions_drop')
    cluster_dd_menu = cluster_dd_block.find('.pull-right')
    cluster_dd_menu.click
    all_clusters_tab = find('.hover-el', :text =>'All clusters')
    all_clusters_tab.click
  end
  def delete_cluster_on_clusters_page
    cluster_block = find('.row.padd_left_md.padd_ri_md')
    cluster_block.click
    settings_button = find('button', :text => 'Settings', :visible => :all)
    settings_button.click
    uninstall_cluster_btn = find('[data-btn="uninstall-cluster"]')
    uninstall_cluster_btn.click
  end

  def switch_to_cluster
    cluster_block = find('.row.padd_left_md.padd_ri_md')
    cluster_block.click
  end

  def  go_to_stats_node_page
    find('[data-link="open-stats"]').click
  end

  def sign_out
    avatar_icon.click
    sign_out_button.click
    sign_out_message.should == "Signed out successfully."
  end

end