//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fc_native_video_thumbnail/fc_native_video_thumbnail_plugin.h>
#include <rive_common/rive_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fc_native_video_thumbnail_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FcNativeVideoThumbnailPlugin");
  fc_native_video_thumbnail_plugin_register_with_registrar(fc_native_video_thumbnail_registrar);
  g_autoptr(FlPluginRegistrar) rive_common_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RivePlugin");
  rive_plugin_register_with_registrar(rive_common_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
