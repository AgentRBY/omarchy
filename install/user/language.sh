# The language picked at install (/etc/omarchy/language, written by the ISO or
# by first-boot setup) becomes the installing user's language: the language
# file and the session's LANG for the first login. Applied once, so a language
# the user already chose stays. The install generated the locale system-wide.
language_file=${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/language

if [[ -f /etc/omarchy/language && ! -f $language_file ]]; then
  code=$(head -n 1 /etc/omarchy/language | tr -d '[:space:]')
  if [[ -n $code ]]; then
    OMARCHY_LANGUAGE_FILE=$language_file omarchy-language --no-session "$code" ||
      echo "Could not apply the install language $code; keeping English" >&2
  fi
fi
