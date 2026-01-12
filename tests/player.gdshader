shader_type canvas_item;

uniform vec2 mask_pos;   // top-left of mask, in local space
uniform vec2 mask_size;  // size of mask

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Convert UV to local pixel space
    vec2 local_pos = UV * vec2(textureSize(TEXTURE, 0));

    bool inside_mask =
        local_pos.x >= mask_pos.x &&
        local_pos.x <= mask_pos.x + mask_size.x &&
        local_pos.y >= mask_pos.y &&
        local_pos.y <= mask_pos.y + mask_size.y;

    if (inside_mask) {
        discard;
    }

    COLOR = tex;
}
