import os
import sys
import shutil
import re

def log(message):
    """打印日志信息"""
    print(f"[LOG] {message}")

def clear_directory_contents(directory):
    """删除指定目录下的所有文件，保留目录结构"""
    if not os.path.exists(directory):
        log(f"目录不存在：{directory}")
        return
    
    log(f"开始删除目录：{directory} 下的所有文件")
    for root, dirs, files in os.walk(directory, topdown=False):
        for name in files:
            file_path = os.path.join(root, name)
            os.remove(file_path)
            log(f"删除文件：{file_path}")
        for name in dirs:
            dir_path = os.path.join(root, name)
            os.rmdir(dir_path)
            log(f"删除空目录：{dir_path}")

def clear_file_contents(file_path):
    """清空指定文件的内容，但不删除文件"""
    if not os.path.exists(file_path):
        log(f"文件不存在：{file_path}")
        return
    
    log(f"开始清空文件内容：{file_path}")
    with open(file_path, 'w') as file:
        file.write('')  # 写入空字符串，达到清空文件内容的目的
    log(f"文件内容已清空：{file_path}")

def remove_feature_contents(feature_folder_name):
    """根据提供的feature文件夹名称，执行删除操作"""
    base_feature_path = os.path.join('feature', feature_folder_name)
    
    # 删除src/main/ets目录下的所有文件
    ets_path = os.path.join(base_feature_path, 'src', 'main', 'ets')
    clear_directory_contents(ets_path)
    
    # 清空index.ets文件的内容
    index_ets_path = os.path.join(base_feature_path, 'index.ets')
    clear_file_contents(index_ets_path)

def create_view_directory_and_file(feature_folder_name):
    """在feature目录下创建view文件夹和文件"""
    view_dir_path = os.path.join('feature', feature_folder_name, 'src', 'main', 'ets', 'view')
    log(f"创建目录：{view_dir_path}")
    os.makedirs(view_dir_path, exist_ok=True)
    
    file_name = f"{feature_folder_name}.ets"
    file_path = os.path.join(view_dir_path, file_name)
    log(f"创建文件：{file_path}")
    
    with open(file_path, 'w') as file:
        file_content = f"""@AppRouter({{
  name: "{feature_folder_name}/{feature_folder_name}"
}})
@Component
export struct {feature_folder_name} {{
  build() {{
  }}
}}"""
        file.write(file_content)
        log(f"文件内容写入成功：{file_path}")

def update_oh_package_json5(feature_folder_name):
    """更新oh-package.json5文件，添加依赖项"""
    package_json5_path = os.path.join('feature', feature_folder_name, 'oh-package.json5')
    log(f"查找文件：{package_json5_path}")
    
    if not os.path.exists(package_json5_path):
        log(f"文件不存在：{package_json5_path}")
        return
    
    with open(package_json5_path, 'r+') as file:
        content = file.read()
        dependencies_index = content.find('"dependencies": {')
        
        if dependencies_index == -1:
            log(f"未找到 'dependencies' 字段：{package_json5_path}")
            return
        
        dependencies_end_index = content.find('}', dependencies_index)
        if dependencies_end_index == -1:
            log(f"未找到 'dependencies' 结束大括号：{package_json5_path}")
            return
        
        new_dependencies = '\n    "@same/common": "file:../../common/utils",\n    "@ohos/dynamicsRouter": "file:../../feature/routermodule"'
        updated_content = content[:dependencies_end_index] + new_dependencies + content[dependencies_end_index:]
        
        file.seek(0)
        file.write(updated_content)
        file.truncate()
        log(f"文件内容更新成功：{package_json5_path}")

def update_hvigorfile_ts(feature_folder_name):
    """更新hvigorfile.ts文件内容"""
    hvigorfile_path = os.path.join('feature', feature_folder_name, 'hvigorfile.ts')
    log(f"查找文件：{hvigorfile_path}")
    
    if not os.path.exists(hvigorfile_path):
        log(f"文件不存在：{hvigorfile_path}")
        return
    
    # 删除文件内容
    clear_file_contents(hvigorfile_path)
    
    # 写入新内容
    with open(hvigorfile_path, 'w') as file:
        file_content = f"""import {{ harTasks }} from '@ohos/hvigor-ohos-plugin';
import {{ PluginConfig, etsGeneratorPlugin }} from '@app/ets-generator';

const config: PluginConfig = {{
    scanFiles: ["src/main/ets/view/{feature_folder_name}"],
}}

export default {{
    system: harTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins: [etsGeneratorPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}}"""
        file.write(file_content)
        log(f"文件内容更新成功：{hvigorfile_path}")

def copy_and_update_readme(feature_folder_name):
    """复制并更新README.md文件"""
    # 查找CommonAppDevelopment目录
    common_app_dev_path = os.path.join('..', 'CommonAppDevelopment', 'feature', feature_folder_name)
    readme_path = os.path.join(common_app_dev_path, 'README.md')
    log(f"查找文件：{readme_path}")
    
    if not os.path.exists(readme_path):
        log(f"文件不存在：{readme_path}")
        return
    
    # 复制文件到当前feature目录下
    target_readme_path = os.path.join('feature', feature_folder_name, 'README.md')
    shutil.copy(readme_path, target_readme_path)
    log(f"文件复制成功：{target_readme_path}")
    
    # 修改文件内容，删除'product/'路径
    try:
        with open(target_readme_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except UnicodeDecodeError:
        try:
            with open(target_readme_path, 'r', encoding='gbk') as file:
                content = file.read()
        except UnicodeDecodeError:
            log(f"无法读取文件，编码问题：{target_readme_path}")
            return

    updated_content = content.replace('../../product/', '../../')
    with open(target_readme_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)
        log(f"文件内容更新成功，删除'product/'路径：{target_readme_path}")

    
    # 使用正则表达式匹配gif文件名
    gif_pattern = re.compile(r'([^/]+)\.gif')
    gif_matches = gif_pattern.findall(content)
    
    if not gif_matches:
        log("未能在README.md中找到gif文件名。")
        return
    
    # 假设我们只关心第一个匹配的gif文件名
    gif_filename = gif_matches[0] + ".gif"
    log(f"找到gif文件名：{gif_filename}")
    
    # 获取gif文件的完整路径
    source_gif_path = os.path.join('..', 'CommonAppDevelopment', 'product', 'entry', 'src', 'main', 'resources', 'base', 'media', gif_filename)
    log(f"查找gif文件：{source_gif_path}")
    
    if not os.path.exists(source_gif_path):
        log(f"gif文件不存在：{source_gif_path}")
        return
    
    # 目标目录
    target_media_dir = os.path.join('entry', 'src', 'main', 'resources', 'base', 'media')
    os.makedirs(target_media_dir, exist_ok=True)
    target_gif_path = os.path.join(target_media_dir, gif_filename)
    
    # 复制gif文件
    shutil.copy(source_gif_path, target_gif_path)
    log(f"gif文件复制成功：{target_gif_path}")

def append_dependency_to_oh_package(feature_folder_name):
    """在oh-package.json5文件中追加依赖项"""
    oh_package_path = os.path.join('entry', 'oh-package.json5')
    log(f"查找文件：{oh_package_path}")
    
    if not os.path.exists(oh_package_path):
        log(f"文件不存在：{oh_package_path}")
        return
    
    with open(oh_package_path, 'r', encoding='utf-8') as file:
        oh_package_content = file.read()
    
    dependencies_index = oh_package_content.find('"dependencies": {')
    if dependencies_index == -1:
        log(f"未找到 'dependencies' 字段：{oh_package_path}")
        return
    
    dependencies_end_index = oh_package_content.find('}', dependencies_index)
    if dependencies_end_index == -1:
        log(f"未找到 'dependencies' 结束大括号：{oh_package_path}")
        return
    
    new_dependency = f",\n    \"@same/{feature_folder_name}\": \"file:../feature/{feature_folder_name}\""
    updated_content = oh_package_content[:dependencies_end_index] + new_dependency + oh_package_content[dependencies_end_index:]
    
    with open(oh_package_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)
        log(f"文件内容更新成功：{oh_package_path}")

def append_dependency_to_build_profile(feature_folder_name):
    """在build-profile.json5文件中追加依赖项"""
    build_profile_path = os.path.join('entry', 'build-profile.json5')
    log(f"查找文件：{build_profile_path}")
    
    if not os.path.exists(build_profile_path):
        log(f"文件不存在：{build_profile_path}")
        return
    
    # 尝试使用不同的编码方式读取文件
    for encoding in ['utf-8', 'gbk', 'gb2312']:
        try:
            with open(build_profile_path, 'r', encoding=encoding) as file:
                build_profile_content = file.read()
            break
        except UnicodeDecodeError:
            log(f"使用编码 {encoding} 读取文件失败：{build_profile_path}")
    else:
        log("所有编码尝试读取文件失败：{build_profile_path}")
        return
    
    packages_index = build_profile_content.find('"packages": [')
    if packages_index == -1:
        log(f"未找到 'packages' 字段：{build_profile_path}")
        return
    
    packages_end_index = build_profile_content.find(']', packages_index)
    if packages_end_index == -1:
        log(f"未找到 'packages' 结束中括号：{build_profile_path}")
        return
    
    new_dependency = f",\n    \"@same/{feature_folder_name}\""
    updated_content = build_profile_content[:packages_end_index] + new_dependency + build_profile_content[packages_end_index:]
    
    with open(build_profile_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)
        log(f"文件内容更新成功：{build_profile_path}")

def modify_line(line):
    # 在最后一个右括号前插入 "",true
    parts = line.rsplit(')', 1)  # 以最后一个右括号为分界点分割字符串

    if len(parts) == 2:
        print("line:" + line)
        print("parts[0]:" + parts[0] + " parts[1]:" + parts[1])
        line = f'{parts[0]} "",true){parts[1]}'
    return line

def find_and_append_line_to_ets_file(feature_folder_name):
    """在WaterFlowData.ets文件中找到特定行并追加"""
    # 上级目录中WaterFlowData.ets文件的路径
    source_ets_path = os.path.join('..', 'CommonAppDevelopment', 'product', 'entry', 'src', 'main', 'ets', 'data', 'WaterFlowData.ets')
    log(f"查找文件：{source_ets_path}")
    
    # 当前目录下WaterFlowData.ets文件的路径
    target_ets_path = os.path.join('entry', 'src', 'main', 'ets', 'data', 'WaterFlowData.ets')
    log(f"查找文件：{target_ets_path}")
    
    if not os.path.exists(source_ets_path):
        log(f"源文件不存在：{source_ets_path}")
        return
    
    if not os.path.exists(target_ets_path):
        log(f"目标文件不存在：{target_ets_path}")
        return
    
    # # 读取源文件内容
    # with open(source_ets_path, 'r', encoding='utf-8') as source_file:
    #     source_content = source_file.read()
    
    matching_lines = ""
    # 查找包含特定文件夹名称的行
    pattern = re.compile(r'\b' + feature_folder_name + r'\b', re.IGNORECASE)
    # match = pattern.search(source_content)
    
    # if not match:
    #     log(f"在源文件中未找到包含 '{feature_folder_name}' 的行。")
    #     return
    
    with open(source_ets_path, 'r', encoding='utf-8') as file:
        for line in file:
            if pattern.search(line):
                matching_lines = line.strip()

    # 提取匹配的行
    line_to_append = matching_lines
    log(f"找到匹配的行：{line_to_append}")

    # 修改匹配的行
    modified_lines = modify_line(line_to_append)
    
    # 读取目标文件内容
    with open(target_ets_path, 'r', encoding='utf-8') as target_file:
        target_content = target_file.read()

    with open(target_ets_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # 计算倒数第二行的位置
    insert_position = len(lines) - 2

    # 如果文件有两行或以上，则在倒数第二行的下一行插入一个新的空行
    if insert_position >= 2:
        lines.insert(insert_position + 1, '\n')
        insert_position += 1

    print("insert_position:" + str(insert_position))

    # 在新空行后插入匹配的行
    lines[insert_position:insert_position] = [line for line in modified_lines]

    # 将修改后的内容写回目标文件
    with open(target_ets_path, 'w', encoding='utf-8') as file:
        file.writelines(lines)


def main(folder_name):
    """主函数，接受一个参数，即文件夹名称"""
    if not folder_name:
        log("未提供文件夹名称作为参数。")
        sys.exit(1)

    
    log("------------------------------------------------------------------------")
    log(f"开始处理feature目录下的文件夹：{folder_name}")
    remove_feature_contents(folder_name)
    log(f"处理完成：feature\\{folder_name}\\src\\main\\ets下的所有文件和feature\\{folder_name}\\index.ets的内容已清空。")
    log("------------------------------------------------------------------------")

    log(f"开始创建view文件夹和{folder_name}.ets文件")
    create_view_directory_and_file(folder_name)
    
    log(f"开始更新oh-package.json5文件")
    update_oh_package_json5(folder_name)
    log("------------------------------------------------------------------------")
    log(f"开始更新hvigorfile.ts文件")
    update_hvigorfile_ts(folder_name)
    log("------------------------------------------------------------------------")
    log(f"开始复制并更新README.md文件")
    copy_and_update_readme(folder_name)
    log("------------------------------------------------------------------------")
    log(f"开始在oh-package.json5文件中追加依赖项")
    append_dependency_to_oh_package(folder_name)

    log(f"开始在build-profile.json5文件中追加依赖项")
    append_dependency_to_build_profile(folder_name)
    log("------------------------------------------------------------------------")
    log(f"开始在WaterFlowData.ets文件中找到并追加特定行")
    find_and_append_line_to_ets_file(folder_name)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        log("用法错误：请提供一个文件夹名称作为参数。")
        sys.exit(1)

    folder_name = sys.argv[1]
    main(folder_name)
