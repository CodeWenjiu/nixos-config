__default:
    @just --list

# Enroll a fingerprint — Usage: just fprint right-index-finger
[group("fprint")]
fprint name:
    sudo fprintd-enroll wenjiu -f "{{ name }}"

# List enrolled fingerprints
[group("fprint")]
fprint-list:
    fprintd-list wenjiu

# Delete all fingerprints
[group("fprint")]
fprint-clear:
    fprintd-delete wenjiu
