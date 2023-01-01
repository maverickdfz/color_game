shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float mixture = 1.0;

void fragment() 
{
    vec4 tex = texture(TEXTURE, UV);
    COLOR.a = tex.a;
    COLOR.rgb = mix(tex.rgb, color.rgb, mixture);
    COLOR.rgb = mix(tex.rgb, COLOR.rgb, floor(tex.a));
}