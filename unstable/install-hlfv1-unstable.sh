ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground-unstable.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1-unstable.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 
�>Y �<K���u��~f��zVF���Y�j&��^5E��=��I�������1E�$J�&)Q�`��%>�h @��"��h � �>���9r�!H������o����ݢ�^�����X�T��t��4�@>M&]*-�P1L�)���@�u-�c���'	��?m��!� qY��B�[~�OR�-�ۋ��R��#�8���R!ݐT�>�` }$��8 N�������� ��"��֩�B�u'�e�� ���/���\��6����KB|�G�����NRF��*��s$6��E����f��!�|V����^,��Dw+��mIF��p�t���%q�����8��c��!�f������q�	����v&F�Q���}4�r�Tu���Hb��}�g8[��duR$�$9��H�2R�hiG�[H�z�k��խ��J��.�bwtM<$��a��{��y�V�|C�+��t�&�/XCK�l���!�bnC�A7M�%
�H�M4]��::"�,���nSr�lN�!a�>�Y`�xm#uy�ȫ�E�-��<��jWz�u�¬$A��}
���؝�Y޳��'������Bma(��HWy�fV�ۋ.��=�W�(�Zh䳝?6 ��|$:+��0��v��'�d0r�޸$[���̿���Z
-�1';�7���������sp�?�)��%Xv����O���M��p2t1	�C�ɞ��Lؗd
J�h��.DP*��tN�B,��D{�� G>������;y�6|��_��W^��S����Ol�
v�H�Л��l�f�����sH`�%��,�������Pm	3�V��ܩ3��N��_��>�A�k�|_٣_��<jN�l@���$#�8c�;z�m[槫cw��n��	-�R/	�����q���Յ@�Մ=l6pK�k�	;����3�$N��kZ�*����1��S[�W1�klq�Z�cɪ�B�y�g��\~(�N#[���'f��r��SoNF����d�� ��$v����s��������tyg��`j6�^���1��(PR�i�x��篼O��[��򾃳HU�<vL�	�M	�'ON�8/ݡy���㡱d�ʑ!���*�w4���kaK����5�����q�����P��q�������u����GPl9-I�߆l�eg/��r����������Y-�D�p\��)���ol��y$}c>���	R��������y��Z�?�{�����7����n�����?@����H(�����7o��^,Uxz"����d��2��4����|�ń�%;�s}�b����W�f[�������߽�����7����\�!��?�"��ܽ���{$14B��ه�ܝ�xl����#�o��[1�*����.4�������@���p�L��L_�B*Wz��Ь����ٮNa�3����%�Wm���2����B�}Q�
�T6�7~u�e6��ZA������Ϡ`Á��=������5�����$@��Φ�)�[��Vaa��My�%�PzQJ�\�\:[��m��!��@x�Z��.��~J��>�{B:z��O��}���;�񰀟�g���������|�.�#���3E=�ՄT��&ҽ���gK
�v[{L������ ̆u�%�\����]W��]�"�7'�m��k�u}�?�����������p�҂��������~�$w�p���Φ�y����
�v��o��qvV�uÄH�U�3�����Q�����}`G`�>�[<�_9��ݡ��q�lMrN��Nׄͅ8����Y2����Z��}�MbǾ㜰�]�.j���>��#��W�?����F�+��k�}n8;h
��,�h��C��=���G>�����fZm_e8G�/�A�����Y�
�5��4�2�B��͙�pT�b���������_gS�<�G��Adg�7���^طצ�cb�h m�`\8�o����q,���m�l!��'˪(���R��>�>�J�/�A��J�i�k��m����?�S�C]��>JTT�2�7��\<�����y���z��"�n��F�7?��n�W��ýbۡ}-�ǖ -���sS���`4Iq���mw hu����b�3�bD?��m�k�h�Xt���n����}��0d��3k�t����N�{�֞x�
�"�Bc$�E����E}*\��}"\\Ե��@�H��
W�R��}slKs�J3��.	u�,=���y�x��]q߹���wWz�T��In�&Wi������+��>���U�k^��/��
<.��GF�����M����p/����g�� ����"�]��	 �>/A��[w߽�����?��}1ß��I���?�o���l��v$��͐�B(���~(�Ƞ!Šq� �@�t���������?��v�o�z�/�?��/~���u|��L��"��G/x/�z\��{=��# f_�b��?���oۏ_~���=��x�������p�T�\����X��9��O��ǲtA��V��,�ױ�N=�V�i���2+���<�J�d�����~�v$�0iLi+�3|I��^��K}+�㬪S�Y-��U����N=V��c F�#qP��AeR
)|�i��`&'�"<�;\�eg����)�IG�#,�A���/�ٽ�$�T�Au���*�d��8E��jB=j�y�j�U2}�P�r?.��J;~2=��Wj�J Z�Uz̼�-���ʧx����(K�q7�X�?�0u.�V��ptƜ��ju�M$�h�@�_♨C$e��<#�s�m����E�gi��2�ʳ�Z'V,�&c�����:�xF�7�R�T�ҝ�~��U[`�ȵ�N��N�Z n��qT�iVZ*1t
���FdC�^=��c�Z
�2�M������(�.a�i���tR�x<I��l=�n�1�T�$R���qǸ�}G��.�V*�������`J%���6� k�P�r�x�.�ub)V�u� � >�S�NE��]t�KamLT&X5s�@/kg�*p4�D���g����q���2����&�l���E����)}�2�� -WJ|����C=�YZ�^k����9��|�n�i�.�Yd�^v
�Q�9�h"��%��ˢ��-Yۘ_X�kl؈Jt	0���es��t:�g�a�KӅLQ(;���`M�G���7�ы2D/�@2jv3�z��O��V�(0�1��fs�rR��ҨY�Z�i�RDM%�V�Dg�q �|�6�QY�n�,�8d<�өs�3�s6r����%\�O<�O �@b��İL���R� 7�T[=�c�l.9m���q-册a�C6ۣ����W��I�1��%F�#�0��E69	�G���b����c'��ҭ�J�:hB�ArZ�jE?n��V<ʝ�=E�J�d�P��dC�����\ی�6�Z�M�OG�6%&*�|�KzW���;xlbt���e<�Q;&�(Hɂ��̀t�M���Ŭ�4كfC����8&Cm/�g�J<�1#J���1��n����W��q@���y�x~:��B#G�����(
Q%�2Ćg]C^��9V��Y�ab��Oャ#	=n�M7kR�q��Gr��@�JF��8hżV[���#�]d���WY�*'�y���h>�}��½!e)]@Y���^y4�w��q�D��*�N"T�/�|e�!+m��"yQIrf�N���[�
��� �T��]��Rt��M�`�L_NY��W���N�\5�i����
]T�܆��!����,I=H�µq���Yc�R�Rԃ���a"������Ҥ�,�i�V�$���9"=�MH�<�7*V���©Lw,�5��|�ʒڦ,�-�2~���.�,�@�B�4I��J �"�d��	�L�lg85�f5""Z!��N����Z�����̴�h�}�$@qdJ�2@�P�S�����$A��AC�P"���1On(��
�ʒ���i8��#A��|��wޚ�x�����vʡR���$��G{}Y?	�ٱ1�E��+�`��v�lWh$�I�
fk�~�u����l��m��],g��.m�X������d"��<�||�[���۞w��[�o������W�E� �=y>�@��å6w<,���eVd_%������2�)vퟧT���C�{�*��?8���|��$N<?�|�O�"�LZ��»??`�5�2L]r����%V�cq	R��Q�h�s��.x�Peu���;��)����;���/��%��_�E7��������o{�����8���3��nE���#���=����/�c��b�8��e��,�E����;���p~���o{a���Lϯ<wI���]U�ٿ|��z> �㬱��Yd�L����b@��Cw����x������۽�^
.�R�W�����<t�y%�j�bk�2�AE�FG��ҩ�u�l���y����uT)O����2|:O�����,��K\�g�n��2���ԫ��P���K��v��:��6�Jn��Zb����L�b%.��x���sZ���+�pY
��EVP�x[�.�i,'s���i,��d�յ�{�+�An��,1�������A!�E�|���]K�+�YNP��E:2Ej%#��[�W�S/��v����)��o���]�� !lX�PvHR$H�$VH�bQFB(��"b�����v���]�I���^׭:Uu�<�������x��b�������De�A3���Q�l��ƴ�
z�����'ܦ�j�ѫT����#�MY\���A��,�@�{%/r1���uml:OT�C���tA��T��0#�2F&��b�XH��Z0j�U�f;�$�D��Y*�0E"����?��6�Iڇ)���(u"���Y�֜%\�����x4��J(H�q�-ȚT�;�7.����SL����>��s��q��\II_?��'T�Ҏp��/���;62��@���g_���s�����p%�n$,�^	{翾�9����o�-aa�HX����cI{� ��1�h��d��Z����fHm�4 ����8r5X���VVns&�p��g��D��E6��VF��l�����x�,�!�m!о1$;�RL33&�b����X:á�q��G}�E��p0�a>�,�5$�4�dm0���I`Ą���B��g�窙.�P�\�5�\��@�C�l!ByZ/�Pa:ՙF��U{�X&�:<�	���H�<��9���k����U#
��Zs��T�4��n��Ҧ͗k��)41+�4��Ո��Y}�I�V3�rp���5�Z�Z�M'�4����h�{	t�9^Z�8J���-~ʰ����;`�z�I�f��^A�.�v�6�d��C��ǣ�>����·��×v����hr�12�t�R���=��m�o@��u��	�����[���e#��6>�T�~`G������~��s[1���������'����[��O��������w����~�i5�ڲ��O������?Ǯm���u�^�+���{�?���)��� z������������������g?����/�'_��}�s?���7�p��I�{I�ϒ����}��o���o������귌��ξ���|�7~�/~���_��������'�ǿ�ݳK@'��%q��;��?|��}���N��	\;�� p ��`7쳸� ����v�N ��-��G�[���#�*�JC_|�þ/hJ���Wor�����Ofo}b��M���5�Ͽ����;�	?:~@�~`*L�?�9@�8���#|$�5�3�V��xg��m�X3��`�X ��53�s�����G��}�� V�|��pG�����ΣO���T���z���@�q���a\�{�q��'��*�7��Ny�1���o����� �o-�t.��s]C.�[�-7ָx�����������J^��|�	j-p�rZ����>u��7�ᰝ�g�� �3!����:~�Ź���2p��`�篼3�}u?��aX��w�Zũ����z^�����Ճ:�����F�q]��:��eu��uS�P��pV7tK�Q�a	�DX������&��,IRڥ��Dk>�^,������"���I��)�װ>���������r2��~�k��C�b]��.���^+��<��;r;Vݘxs��fu��'���tN�rR�2&����L*����D1'��o���?����J^�
rZ|���}I�J��o~����M\�o����齩���9�9x��[PH�/��ᓒ���r��;RfrJ�%R��m㮳y�u
��������m�۝O˥��˿�ͻ�m{��X?�߀W�"G��vS{�U�u<9��h�.�a{0��@7ag��OT���An�n{��e�ݓטЗ�"�M$���î�i�{���b��}¸:�n��N��^��"��.��fzX^��nۿ�Vb�9�R�9%%�E�R�HB� m�T`}	d?mJ��xr����z}F̤�T�ͤߚ]�0ܴ�1<�F�h�_F��ݎ��3#y����W���{l:�_����˗��Xb�ݐ�;+�SQ%��
��������X:�W2��\,)q^o�-R]դ���敥�Kq�m��y��Ĵ���˛	��׉h�^�����x��^R�=O���C~e�%�ew����������M�����6��ݍ�նG��1�O�:����9�i�\s�I�|�M����6���^7I�p��:���{=|оŴ��SN��6���B9�K�^�y�� .��&���}�[n����`#��g^�_�,��qȄ�~�����g�۸q�k/�;��;�������o���/�4�w���Υ'�o?n+E����Mџn6��CB˦��.�����[ot
��qtJ�)�Y�S�S����JN;�a& m�ۯ���������OA�S��a���G�?�`�?<y�o�����?J��� �|����w_��G����k�5�a��7���=a\����e]_�EP��k�R����g��6�?���]����s��}���_pA��#��F��A �O#������ǜ;c{d�� , ��������!���������Fh��:���S�J�4JSl�$4��Y��L����IS$��ZݠHE�0/��j�/A��������!�����`gՔ$�y�|��w����S�.pYIRĞ9�H�D�\I�W�ae�g�ieG�.]J�L��'��0�w��@�����N����Aa2��pR��:%t>B�^Q	y�D�ܨ3�G,]n5�Q$Rh̊
TEےIT����]�E��n��iQ��M1�}�����8uA�a�Q;�q0��`������q�<!@� �������z���4�?����V��$^&B�����?��  �f�� j�MQ3N�3�A�?�F��A X�����a��_������?��7�������
��A�'�����%?�z�*>y�a�WN�R��l0����:��O~�B}L|�����WסU�Ыl���+s5�q%�*�M������-���.�>[L�k���\��T�3~Xq��#����W��٬��ȝ�e�Q��.q��/��&V��ۼ�u�k`��b��ŪwƊ���<���;�ْ�m��[D�Rپ�hĜ˹9NiĩE/��ɵ5�Y� ���x���(�")�#c�|wL�9UPb�ܔ�S5D�����r��Z�aM0�<T���`��^��a��P�����`�?]�� ���-����1�`�I����i�L��������� ����?�����0� �������?t ��˖�B�� ���,���a�������t8��&E[8�b�aQ���-�"Y�o�!hJ��E,�Lg�F������ ���/��qB�CHd�⼖�F��ۨdYCL���Q�|��q�����ڙ/n��1V
Sn��Zm�Y�)�����7�q�L��b81��R�dbx�M+Uh�u�N�������g�8�0��k6�+Z��<a�A���!����������0�?��q:����P(�������� ���� ����?�#l ��˖���� ���p*��;l 'C(���dxX���V�ϴ�����P��i�u���Ϻ�_l?������+W�*�YoKn�����.4��*@��ݔ�qy��f�4#�V�Smu������Y���BzH�q9G�u#3��F[
Z.](�,���(�@v�y����c��&l��¥�j}���v�׸y��#���{���Ut��C|�(��Dny��
���ȍV�U��\�!��A=�p�&;��PS�UHh�â�t�b\Hv2�٩tKZ�Z�i�N�\K�z�<�,hC�S.Ez�.�m6X{:N�9~2�&�Z[�W��J1�9YJ�ĺE�u+
_U�����(�\��!C����_G�?��tV��?����l�/�����0��B���'����`�������um��/�cM�?�A��_N�g��@�=���G����? ���@����?�����_x���`4��뚎��(������Z����[:�"K�$�"L�E,�4Y�fI��@��gG���wS�ܻ� pD���HK�p8L�U�\+5�,����fԣô���"�tI���(����NFhuD�Q�қ6m��ֆ6D$[�{.V��	}Z�3ź�3"RZ�8$&�V1��Y1Jf�C�.5��A��G�S�{d���p������@��ur�����Q�� �{⿞�������/���������~���i
��������!�" ������!7��������89 ��?5���������FhaX��X�^�4Rg4��P�C'X��2h��u]�pg	Ʋ��2������"(�?n��������M#9�6�FU	mTAP�b$��F=��g.����Q��:�;,҄���>��l.���͍D:�H|�k�-"�C�)��U�UMF̑'�"NSG³b��3����Z��>a�1�������O���?��� ����C��8	�?�a����`�X�������_������_	��!l���*���2��U�+��1e,Ю)�6�/rkm)	ݴ��U�^DE�˯�c�Xi~��*�J�͢��T��z�4�V+�83�"�Ԃ[�����XJ�j޹�wn����95V�	.�zQ� q�RAͩ��ZʦH�@��g�Z���{ݦ���QnyM�\�P-�\?ެ�RKM���%v��ʙTTyeYF�LMze��>i��m#�;Hd.��
����*Qѫ�<r"=ܖ�6��me�C23n��բё+릜OM�ԕ���i�A�kM��5�]�5��(�V
���n�HN����-�D6\�Q��cN\�w�s�*m�;��aU�Ġ媲F��|*��[ќ���
�eǻb'����E��
IN3�qG!�Z��9����QZ�fU�9��{:MN�5���}G��a}j�F�攆9�,H^�g�]%�Lԍ�df(�5�����H��u�ZW�E�/o=X(�?��d8����89�����P���5������W� �B�?����?��!<,�K~����0l>�q�4����J��A��ޓ��*�B�@Qޱ�{�h�q`����@�1[�Z- Y�M֤kf��gܱ��!Ġ0m."�������J��g��b$���{={7��e��'�]�Ğٝ������8�~�T���`-�����]]USU�\-2 EHA⡀���"A�/���@> ���d!������Տ�g�h=��uW�����G�{ι��9�^:�/E���d��*�̤t��N��N�f��%@�c�}�Q�e�>�3(4�$iF܁�R��)-z�}����1���~�/�3NPm��J��ꆫ=3�����L�y�0Y�Q��IS�����D0s���P5�p���^0��z"��H�Gά���q��|������B�s������y)���u<���o���	����.%=��v�?��P|�����l�������_��G-��-������l��2�à���c�����%��?��2�}���xm��R��������|���A�s���_*]��O7h��u�H7���=n?������q;��5�&��)'%�t����&%Nϻ�u���o��(�e��9��I�?X�[�����0ɃR��k��AI*�D)��h�$5x���<��Y���:���B���l�m��*�z���24�4���*T�"�Z����z8 �y�9��ئɀ����.җ�䓻��%eȁ}��E�����)�R ��MI���*}�c�#=�{���B ?	m���������u�h�y<<�L\U�&.躪��5]RL��e�]Ni��L|O��w�=����?["�ڠ<Z��	�̨��x���u��������	��>k
��>m
t;I���պ<g⯿�����Gy�d�m�
�p��H���qk�9�oÂ��r`��;z���!��k��!�<'�T�|��t;�]��i<g5k��QPz��Ui�����ЅÞ`��\�qJ��!ϫ}A9���߽u�~=���[�w	O�ZJ��G��~�N,��=BI3��-΢� ��ُiY���!T�T�d>3�o���ʜd����t�
%��v��B�� ����;b�BtYh��rg�rF�x�3� (S*o�MU�͖�/֊X���N\R�hRx��Q�]+��=Em\��ֵ�?.�IѶ��2�Z�?�k���������2����g-���q������)���.#�W&\����z�k0��L�9m�F��%��W
7Yg7@Z W�b+5�[�}�҃ P;�֯�4�,����S��V����µz�պ�M� ���PCxГ|F� ��թ}s�Rg�"=G�?M��������������֕����W��q�����|�N6]^'�l�I����#�n���z)�����Ϲ麧�DR��i�4�%y��xX�0<�\���ϙ<��_����5��蝿���[�~�+�����Y�.�u��5�sx"=@�9����'��{/n���������y��K���9N� ���4qj`�x́i/����oL�s� ��S�?H��d�3H�M|V����fʋ�Ib�xC'���t�;������-�4��N1��u�O�\��h�LĂ�|����zPύ�|��v�${XSŎϓ㇥f���d�T�(_�]jf�9��=�d�ȉd��5g���H��uz�C0�O�&�Dl�k�0�,$���l5���I����޻1��FC-���TDg$%Wk��.����TK-�ƵLS�b�95*bb�8���r\)$��nV�hD��nWC,"��Y�=�WlO��	�=�x±o�+a�!$a�3%lx�%�L���hɚo��t�T���M�i@���d=h�x"�sR,'i���	 ��d���?���f�_���J���j�T6@KJ4�Jg &�'S�V>)t\�RJ� 2\O�F��^6G�j"��
��<�Sh!E��G��`����L/�KDF��PaB$�G�Uӂl�"Uj�hě�D��O2܌f���j9���z�盹n*�N�S�rP-˱|�q�C�/?Xb	�'b)�@,��n�?���Z5�9�uV�ו��D.[�d�9Ro�Wb�R��9R6B����QZ]6PN�-'�P<Q�X�FMЭ�����%�"��d��i6�Lz�%&�șc�rx	�Tb��4�T�T�3���O*eN���p��1�@��d�!-b�����0�Q����tT��n�V��i�'�j��d�K,�ex��&��
���!˒�A�/Q����1ŶF$���bolt����Mx�� (Lyl��z��b��h�ƍZ�Kt�C�&�r�J5�Z�X­�$�GQ�M���
��h6���k|�<F,G��`O%�lh�p�=>ap���0)Vu�HF���:A.(݅�+Y$��-���ۑ�CO0=4�:o咇.��q+ZH��Z��\t���d�"����:������m]a�aۆ�O�u�t��^�x��6�+����z
������O�M���[���=�Xg�Ůr�X�������ɷ��M��3��q���5� /���ȇ&�JF�%~�=�=�fx^�LF�'�[/�g��BN0L]�<����ՓA�#(F�(�4�Į��UV� p�M^ا�k`����M^�m|���9r�cOm|�ߛ��an����wJ�,5��c�����W�ӱ��ms�i�"�lOk��+��i��}��+���EB �o�z��1v �82�:7��=����#���L,/?��~���������`参w�]�'����%�HPk�}_9���p��>(;xL�����1�J��:.L�бX@�/��V=p�z�����.z��lT��4����Akp�wXb���
w�$$zcvW�+�NsQ��d�����ʁ��x�A%A�BdC�?»�T@�W� Q��U��m��L|�Ӯ��$C[������d��01���9��Lgc�<�$c-�v�8�x8��dç@/s������t���ؗ�J�H��e}ON(��0E:A#���nE�Z*ÅiR!����n�q��;��1��CvJK?���^")Hu�e�����ݵpA���$�A..g2��f�9l�8G�u�Ӓ^�>���,(�א>4ULk�t�k�s�n{>�P�I�ڼ�=�w�a��հ\�?~c�Lm��gkX�KѰlK��Kڪ�H~�8�u��F��u�Ogcm��������8ro�X�ʣS�r���Ff�(2����Ef����8k���O<�,C�zWK�Z�0�
E�(Mg�ef^W�~2>�zȴJ����� Q���2X�cT�?�FCO��U32���p��h9j�C��B��~�D�B���Ĩ�U���y�G�,]$c�T�o����ӏv I*��銊�4l��L�Ij�\G�D!�"�a!�%�pI6��~�
��V�@f��P�\D0j�j1���ӌSjW#�G���a��a3�Ǎ9��~\����2��J�R�L_+��V0�m��,�]�3�g�$E̛z�7{�e-��_��^ ߜZ4�FCC0 ֞ON�)�V����9m��E�B��a����1.��~W�����hHp>��>1Ws��<��_����>�3d�{���7����~��}�'�cW�����{�:��N����@Uu�؟�~q�Y}��I����h;��Rpl����?��[���?��'��3��L<��o=�o�}��r��W�~?�� �� ^���#H�o��+z���-NR���]�Q���k��R���O�����[��7~󧾎����?��?/�v~ׁ}���;����C;�0;L�������6H�i;����C;m������ε�-/1��A����z�� 2=,ǂ���``�=) tV�>��7{�}����#���
��Bh�{�g`�uv���J�]�v���6s<�8��H^ j�2�����lNӴ�=3����3co���{fl氙���\`����\�Μ�����imհ͏6x�>sޯ��9�6�'&���Ч��UIٛ�^!$���O��z�c�?x�v��e$�&�o�	�Ch�=r�u*=�q<�3-��� i�k\�N|8�E���&Fj�r#\QM�g������!A��X�:�:�@�i�3me�Q����M��{ 4����s&E�ӳ���>gv_�EB��D"���=8�i��"C���S~%�l}�sIS���㜨��TрP�A�}7Ԧ9�t5Ӑ�Ө�3��5|�E �1N�L��x����P#�x!�.�2��1�B<���9<�N��x:Ep&U��x*t �`?�PC��0)4,��ai��M०��WS�'
��BW�ᚠw%ͨ�@��RW2'W8/��6�ډ�l�5 dN�)��gX��F��!M�2����P�~�ʚ�bI�@�<���[jW@w|,O��U���jODQ����@�S� ��	ʰY��]A,T���gיM�Y�P�t���	C0{���&�-�vϰzQz�<��ޖK9��k1�#��;1`��;7�]|�ȕ����t�=?�wV&��h�`2:Q0V����r02n�B����<��}A����B8_��	?!{���;ۦl|a��*��dC�JM|g�����#p��\��N��@!��(ke��m���,�[8D���z�¨�l�@�
&Di�,����$k ��0���@	�ڳ���~��]\�c���6��-��=�p�!χ{wBi�h�#l"�L^0�x�([8�ݚ�%��������\��)��P��迕�C��!����*��]4A��b�fO���7u����7N@��}(��d�l9Y�H�?$PՅ��p�ˆc	�s*B��&��<8�Hi��@%ڪ�^�� ,ְ���@�� �mg:SR�}~q
�!�P������	o^�˩�id&���|;���<��F�-�i�� �4��4	�{Oڜ8��|�W(�w��� q�7+.clc�ٯ�.0F ,������U%Ѕ��n&\91aZ*eeUf�Y*�#-Z<�]�]u����U�v���.��. ���X(� �p'sF�G�Ю�s<09�7 |���~����� 쌍�N�%5�n�8��4���6�}�@z���C�8^�|����y�/:u�g�FN�w&�|^bY�!x��+�	6w��\t@�I�W��<-o$��l6B���b=��s`>�t=�G�x~�E-$����/�6vK�^+�Kz� B�z��+�^H����G\�@�99�:�a�tvy}�@����Ӆ�9����+�� ��VT��Z�·�w?Gމ�hE`y�ǯ%[��|���{[��wc�M!�bt��9i���M�y��y �ť'DЬ�D&d����e�?�qQ���6�)n��O;%�u��D��*�'h��>?�ca*H�DQ��3�S�.r��1�-ӄ8���`���	P�q q��jsǥkw
v�H��I��:�z�VF��]�ze��_vx��<B*:E�Gx�L�u�H��ĝ��E2����Pڼ��v�:�CjJ�$#�F��>5�M��b��A�7��t&�6@~��w~�g[3�ߪ���uFh�U�D����&u-��w~�Orm�;�N��*��v�9mP�����_�?��V�B��~�5�aL������G���Kd ͨ��
.�BZ��|ع���w�w��ң��.�^�?!,�$��g��C��
P���1B7^���¾�+��$D�QI��$��TFO�Z�k�q3��4���pX�����D��Re�t�����`R��_��r�����RN
�E���X��Y������s��^��E"�F���=�PSśg%�-�e|��fȓ��t����n�uh�S�Sф[(<MVO+"��]Ǖ���7Q����4�,�W�1F���ޣk	5x�w� _�BRc
-�x�
�I_d��qY���d8NARgO�N�%[ �T����/M�'�G�n����=A���=1���b���O�����f'��9��ѰL$T!����ݙ��/0�hs	�f�i/qkr���$m	��rPLJ,P�3� �:�#�#͚B4�����^y2ȧ�i`���3�� V{:���0�|)�\�j���Noj��%�"Əh4&�度�LKULH�'I�B5�>��*��pj�����
���z����?�Eus��u'\�黟���ӫd�1G
h�A�����ɫ��^G���h#���2܎�d��R��KEHWK�]A�� �	(h��&\
�k�HA�yR���\��7���x�R:8��g���OC�Bb�����)���6ɾSqG�$�?���U\:%
���=5<~zT�B[��ʲ�'O��M� o�Go/k����y%�/hJ�,ؒ�*��_��+��������@�D�p�bE����D.y�K2�97iD{�.VM��MZv�B�Ea�jE�o�Z�����h�Q�1`�,���PR �u��&E�~d�8`�OD�H�#�r�sE��	x���B���`޴Y̡1TA:`Y���:9�Q!��|J�nD�|�R+#×��O�g[�9N���>-K���]�ըD8f(Q�(���8I(؍�2rsnQ��\ѩ�U۶��������T0VϬa4���1��X.^�w��f$R�k2� Ğ�D��e�����.��N��}ϔ$�^���	� ��(Y�����b��@B��av��%\$��&�����N(��EF�0Ig�6��B(+�t���3d�l5P�B:��d�5 g ���F��iu�HZR�zw�^�\�W�IOc"Y�}\��`���١�L ���\#�<`���Ӄ����G]I�d��ez�T�B.�;8�#?�~�c����&���=i`ő!�RG��?D����H�V����|���A��1���|RH�J�ސ�#��d�\(C�G��N�O���`�/+I,����~1$�H��2�J� �X��H���׉��[(:�D8L�@�9uC���H.�&�r�U�P\�N8��C��c���1:�l�����A;�!��cT��amo���e��JsπX�������3��әY�G�rU�uR�i�����I��_�3O��)������3N(x�)r��<���g�_s]H�����^�����u ��}}$q�`��K��Vr���*�����px�7M�Ms�Ґ��
�ww��W<��!H������k+ñi@�Mq��9G�5B*7�!8��'�soMM�C���uI����ҧd����]ax��U���G�NN��d�	�����O�+/�8q�-��9GL�=����������J�P���aZcpבRx���h��w
pDP�[Q��`�W@1@���,��ƾl
qT4
�Oȼ�ɸ��_� tH<+244
(q8�N|��B��$gE^�~ӬI}S!�Cf�?'>����*�d��i� S�ňw��8���Ww��v\�aS@'">��	K���;)ǙX#CH���ck)$3�S5�Y����2�-�v*0�䣖y�M��4{1�X�)k)�u�(�P�蕕R������#{R	>��'����E��L�Y*8�6�j�ۃ�쫶b/�ySg�w�W�t)�.�}���a�o���G�������OEN�J������4��s�I��%B�|��}�W�"�����Bm�r��&�m��v'����p�Q���b%��W��cֶI���"B���g���/p����^��+�4��Msx^��O�'�-��.�ى�9�^_q�	�@Ͷ���C?�c��1��h<���Sk�7��y�uW�@kd.��@�.=�j��3�^�*K�^#�S���r �/���ܲѝ��>"�{DJx,����A�I�|�YfB�Ad��Y���e���K�!�����\�2�\����Z�n"3���V�R�&��7`�2����}��6 �{R���"��e�h����)��k8���Fn,	�4PH�O�s��7�F�	z����~�#����Jw����.HЄ��<�e�V8��,.���j����КB��t��)Ȗ�F�����h�+�
�b<��A�C����]�dl[&a�h��ᨛ!"U顁b�x�`�cƮ�c>#�̹&y�F4��ʼ?��: ��I�_�  :��"xoo���--�%���^��B+N1Mk�F���	�Gv_1Ѱ��++�G�@=ӎ�Y�Rw�3��U8@�xy�����e΄7�`�B�Bw{�`D���u!o�x�����&���c9�Մd�k�i��(zz.�� "؄�?Bhé��ql&�EJ_�w<�N�:�mCW?/B�����E���6^.�_W
�㥸ΪK!Ԛ(U� �&JZ����XM��$VsIw����t[U���/׉��1p�X �cQ��*�QE��b�w�?��M�p
�R��?�T�s���?�`�_J�~��>��>|����C}���i>���w��2e���z���(1�����H���i!�a����d�O�Q�?z�#�?���ׁ�� 	>Y�A�߸�w��.������}��������\��#�"�!��A�gr��q�V�����i��〸��[�b�`;����7���\6��sL����9>��jZ�E]�Ӓ"iE��rBN*�ٌ�ֵ/I�U��Iټ�)�.e5A����o���CA\���<��
a�����<_ͪ�+m�;��_ɝ*ר��ogie�U���5w��̫LA�*/n��7v��}j	���]���=itR�m��	�|�ɺlUZ=�z�Woǝ���O��w�+aa��of�&Ξ|ai�����?���No~YO\ڵ����}�k����^�*��Sc�Ԥ��Ҩ���|�h�06=�[
�`��\&l�����q��2;>�E�� ,������(D���lP��7��ɱ1��\|D؂�OȤŰ�O��/`_Mf_Mf_M��j�Wf<�����}���0�/���s�=�o���c�۠�E1��3�����6��}�Y`C���,����WP�����B>�����1?]<�Ǔ�o�W�r�ް���<�8�NDEԯ	�Q��Բ�������ܬT�ߦxZ�)����E�A[^k����|L:����U�yќ%�$�Q��ƕ����nXX�C�yq;����Qu&tn�3����:<k��{?A�Vd]��E�6�Ug�Gt��rk9���-��ז˃��D�\�������á���:J��VE�]� a�q��$�s��[���ݒgޘ�ܔ�Yc��<�ʭYݒ{b��y�f�]u0�w��y��8���y��uUn����͸�����BS��ɳ��;����hJ�AQ��W�z.=I�Y�԰�+����n��L[n�뇅�q�k�o�J^�҃R_�X<��Z���c_h��	U�^�'=����A��O�E��#2�/�����f��� ��?����_B����?&ؔ�g��퀭��Y�c��������7��;�cs��'��ˀ�����
�����ĭ����L�3��i�����lL�g)�Mg1�w%����ݴ�-���|&')�_໹����*���ՄlWs邞����� ����� ����r�z��;iպǳ�M��WNGΉ~[i�ڗ�|���R�is�x^{�Ǥ�y���݇���a}|t�*?�g#}tܼ�O���ǩQS�F�0���O7���<��p<J?ʥ�1iwŮt3��騮�{�����6�v��� n�����.`��Ƕ�۠�������h`�?��g������?l������`�_�;�c������������lN������`+�v��������/���UJ+'������D�����ˇ_���@V�fE�%��P�]w�N���I��V�,�f�eYn��g�r"?��;�����~%7R�e]�sUf���c6s5����T�|:-��rG�8�\��%�$>a��;�
G�CI�lX"�"�᰾����
wI��D�͒<#�s�nK�R��nUd|�C���l��@�z\���r�v��7fj�0E�祧�B=�x�R�j�,]�O�%cpc^)����J�&����>�(������pa&��^�z��˥�u2R�Ƿ���ˋ^�~trujW�j�o�����^�m�t�qx!��A9�n&��c>wy����� l�����������?�X�����m���������?+�olE����V�g�V���������B¼���bF`�,��?;�es��럹�[q��-�?/1�?`�?�����q��m���L��_V������y%��5EԼ(t%#�f�9�P�BW�M׺ZZ�󅌐�|^-�]>k�\!��v��;C����u���f�_,���?N�j����y�_�]�+����0U�t��xvt�~n-���f����!÷���:��5m�S�n�O��2��=ވ)�·��L�<5�ӥv~�Vg���y(��B��xv���o�+�7��3i>`��~z�[�n�A�����?�ϲ�_,�>�_]�_�����������8���������ٖ���8������b���a����A���1�Ĩ�=�O�9����L�o\����?c���9���L�oZ�������l��/��\���L� ���d��"$A%^�2����bW�񙴦i�t7]��]�P
��!�B�� .���������������ݢk�V�޸Y�����^�!�C9o�g�=�y6�c6Y[�}��e�Ԩ�w�=����E�(�]ɝ䫥����앇�~4�?���ŭ�H�]O5��9���=iw�Ȳ�Y���3�bO���!�G�Xb�H��̝�B�l!)� �����[ 6'���L����Z{)���&��X��8�c[��;��_�NA��ck�R���OGI�����A�r
����?	�����y�t:�ߓ�;Z:�/�L���Jǂ��GI�����_��{��c��ɯm��\Ӻ��*v�@�K��.�/;ܱU��F�!��������V>�n��t;�T�q��KU�Ts�8��S��*F*΢�G�V`���<�óy�N\<��:�G�]Q�E1�m���f�}�����B�Ӄ�e�n�+�י�Wfg�V�SrȩF�q]��)�iڍ�iv��v-W!c�<Ԫ0��%�j�Im��y�5j3=�I~;��a�'46rw���U�U��F�Q�ݿ/N���M.��F��RV���]���y��<{ׯ<f>'�J���}n�1")o�HF����H���,7��;S�ﻕ��ۂ'ˑZ��D�[eÏr.���(9���K�2�>(��F��8(0o��ϩԴ9ə3c�ox�CRN��2Sȱ��������&���t��X�M���s��f>]�ڛJ�M��1��4gT���CM�5��fqV̤�_�w��yP;_�r���E�����}������_��^��^��)������I�<���*�d�On����I����_��L��#���_��r���s�J|H�>o��Z��{\��2���_�r~��({�jKk�f�80�V��P/Y��ZP�#�McW�-���>��B�5=��Tq���"��,MoKfӜ�>���Pk֍���:w��;�8�D(.m�]�f���q�H�Z}�����~���^��>j�����v��C��ew��R��Y���7�����*􅼘�/|���͒����H�y95���懛;�ЩTS_-��$�7�y�Z*	��0٘G?k���8�3�<5��������(����u�����m����O����%���6�_)������Z
�����`�?����O~�?��������� �b:�����OAv��!���Ϭ��
��)E���ɦc����T*���H������������
���Z�(�_��2�x<����z�Ի�x�����TTJ&��A"#&�	)���� !IѴ(�{��x"x��K'`����I��������0��E��?�?�ʷZ�����[�/�0����J��G�Cz�1�O�=��h7��A�QL��LS�ҹf2����C��#�X�����������H���z;�K�r��Ǌ�]5?󵷱wq���^�^����J"ft�����u������2��A��:N�F!Hg�\�β���٥��=��'8}[|;�
.34t1�(�((#ʹ��h*z�=�Ͽ��@*�,}�@ҭ�=�[��>C�:�L��Uϲ���-'��TR��&-�|AM�j���{i~+(<�~���hs�r��v.B�b �$:�;6�H �#�>��?����W
8+��t��%]���j�cRS"u3eu��K��dRO�������+(�H�5�^2��)���S�v������?���?����q��Y��(
��,Jf���Y"%�0��h*�P���1�DD!�p����aB���NeCS� ����"��*�n�!r�:"Yb��C���������
[a�g@ycA�g�9Ba�Vq <�
�o=dEB;k^y��󮅍�ax~�kPQ��H��,���B(�'C0Ք�X�}�+:����o�dU2��0����� �dp(g���AV�^����t�k�-�ɳׂ��<�e�\���:�}�7>�6�˱\���Y��v��R��e��F�
�b�L���<����'_�kl��(\c��Z�T}�Þ�!b�4���3Pt��͍m�*X��u�. ?vB���02\�~#�V�����,�UP�͝Ő��n�zm��XI���1�m��Y�ݎ���ظF��g��?����r]`HbВ�у��^�HSg�q/��n_6�(��Vd��5�����hңA �0�Ҭ-d��ኜ�6<1��D�-d��K�K`?��z�^�|��3I�<�����!YXΉ�D�{䜛�K}�`~r�nU[�3bY#�L����k4p���l~�<FZ�!G�_ڨ�@�X��KV�G	�Ƀ���Ш�Z�1D	�*��+hM�W��]%���B��#B�v�9Ȟ�78��/3�z�Q`��g6�n��J�m�[��q�,�	0��R�^��2���ڥelu�s��2&������B�Q���'�� .^�w��`D����`���aR�ɂX��< �Y�����-2�+'pKB�8x>@�4ߨ+�&�*�Ko܎�O�R��+�n��ǀ0��W��s�}���`,Y��TC���f�����1����XCl)���K��ó�v��!\9�E�a�5%�"��.5x�2�y_zfG�B&���ԂT��Z 	�-�@ra��
H.L�&�$��{q
C��5�.4�7,^��[6/�>5���ֵ�����0Q��0_%(ȷ@��L��1<{�Ȣ-��F;_.��_.�-�,�06��T�����I�O�N/��x(q]AƖI/*���M*s!-���c���b�?[
�gSڬ1�5g�%�ʎ��/��7��!.��d��u�ь1~�nt��E�h���G�Ґ+tB�d�YK�D��=�YU�^CU.��TE�'�OVn�E^M{�&�X(Є�&�Մ�SՄ�5Mx���0�BM�NM�l�/Tu��)/:�!	�v��軝��;�3�Dlu�7�����"�Q�7TKH5�>��@�D�2� �s�n�����9Yg�1
ln��9HM��%����K��[�d��W��'R����8:���?���^@$��%�v��g�-��Қ1�(6��V�l�g�q�2K
�UE2M�7we:ۛ#0��Ѓf*�	CC�<0�3C�*�����	����e�2���Z/�y�k/ ����3�G��.��ɧJ����pSoUX58P�B�Ui��W1�����H�ђ�}���L���'��K�R�)K��.��@�k�p�$j��*V� �Ʋ�gԄ�1E˖-[���+�PTO-�h��S�"Yh4ѵ;��h�j��60�I^ ����K�M��dXx�po6�a���yn��q����Dы�q�·r��b��L�6�@�z:�MW�ᐠ�+JV�<9-OR��)�H�uCa�i��i�÷X�u���|�ct�yTԯ��EDEF�~�m�Ω�rM�hh�9�!� (����`���Ff��>\���<Q�E`�s<���&��]l}`�����ښ��Pkj�0<!	ڵ�%����[��z���+�0�́����N6���c���DZ�B#�� ����O,(b����=���-
��٤�& ��6\����Ti�z~�(��ɧ!7���;�/|��8M�̦�rx�D0�]'���|_� �4L2?WE����p�(ق����4���Ԟ�а����1���x/0?~2�V<_؈x����牡\.�~[��S|�P�m��z�i*a����x�X��"A!o]���Rl�b��_K���.�7B�^�X����ފl��G���Dc4�= (�6�9m4��y�s�><��)SOv�h����<�@�x̡E�<(
��̮Mh(�k2d��}��p㰮A�j���x�[���f�dI�2Ľ�.tfc~�Ee�����Ǩ]���҂�nxE?�\L�z,���)��Ph�{���홂8�M'kF&8�?_�%]��&�|�l!'h�!����%:��֝� +��rFy�'4
���8�/�[#C�nbC3����?��g�]�gb�<�c
v��/3�;�Y"_YOｓ������Vmy{Hϝ�^2��>�v�%�9d^���A�H4�!�����l@Z�ʝ��A���!�B�l��B���^Z�d��/`hp��	�kPY|;�gy>t�2;�'���ג��s���"I�y
�A���cf֭ ��J�̅S|��!�8�Jd��, {ڳ�<��=u�߳�S�?rR�:e�7����?�ĐH#\"�	�;��]�'�ym�6H{���@��E�K������#�I���$�`���Ϳ"=Y��sDQo� [x�b ��%,z.���Ul�)IS`��4�eJ�ْhbؗ3�8͘/��>Nv��9�8�|��c�r�o��<�g���3tq�U�>��7��M �6��Y���X#�Bcy8�Po�lnLT��AS��oЂ�3����c�(<X�q�aF�{H���O����z��������d"�8J����]l������0$豁�*?o� ��^�w�i����K�s����I�]�Dp`^Pn���]5n>3�a��K,~4��V�$�x���H������b�cn��MIs?]�C����Sh��qcq�i�Mm�\ě�D�1�(l��Fh��Y�,y�uC��
���xiE9����M�㲉TpEE��m����w v�,�X��Ӊ���Q���_u�c��ʪ�ͫ0kx	Y[,5c��Ld��hp������j����1n
�����ߋd���]�}�$Cz�c��Eg̓ &�"����=k&��$�����d,����9�ȱH�r���-�ku�3��+x��@�dܓ�?(Ii��o~�OY�ۘK��Ek�F��x���O����u�� �ﬢ;ʫi+�ݚ`��O'S��ҙ���Q�w��C�0^��}�g^@.*�5�Ǉ/���v�(X����(�?�l�J������hcl������¿ZopR�9l��E�O��ԛ>�ޫ����3~����?�z� -[;�y5�+%]�E#�D=	t��;�:0>z}
��m���t�35�~�?J��#��.�?��; ��>F��_������O�W��x��H����?
;R��[��+���/���e������o"���(�T�חO6s����e�ڟ�̈́A���VL���-��ڻ�vH��/�y���7~�g�w��S���Qҩ��K��#7����A��!7,����$�\]7�m��?�?/q8+j澋*��L�����s9C�äȂb��������v�M�W��xK8��#�����Mc*�k��#<�QK��(����<W��
��$�Ekl-�r<wK�2��{�!j�G�7�\��i��*�yb߶�>��'q�;|Gȯ�>7��v�Q`[l�(aK��Mv�&Z	� #���yS�0xMܰkό�I�n]�����|���:���F�
��B��ҥ(�ɱ��ڬ��y�n��Z ����bHm5 ��5�z�z�����tϭt�e��6���t��ϋ6������"�����;J:��g��c�*$�)&�����?�Ŏ���DV��x�������;M�Fؚ�RE�ؽ A���`�M#*x���[ ��wU�X,�b�����=ܟ�9�)�Xz�?��v�������T"��1�`)2��Fx�a��eտeڟ�_x���c��b��zgv�{ǳ�\vg{e�;�^�$�c�����$���3q�q;��$N"!�T��JK���G�J�� VT����
K�> �	i�"��ܛ�{������R��M����������8��s���L�G��$�F�����9r���CN���DN��	#ǙkW�더�V��H�8��q�̎ufEqj�3��>�w�����I�x�	$=�����?2�^��q�Ý�q�/���k���0!��O�b��\)T��X*�g�a%��CBR����5�$h�665E��H�ƚ��=��
o���sJ�<�2��!��eV�o��8�� t� B�MSZ��I7�:�v���l�֭w1���+̋�q{�Hw@�''���8�1%�OW{`�Yh��y�t�?gh{Nz�ݷ�d��!Y!��W��Q�ĮRw��l#���b2=�W'h���6�ض��z��]o�ҁ;�'����
Jo��5�$��m+�h掏�R�:�n��JKo�Ko]����Ξ�J��p���\����/���^��̼_}�🸻��G��?y<��8���#@/~��H.���s��wy���������W�Y�Wұ�v��㶓��'�b�c��8�7	�F	���lfwL��;v�"�6�`6��I��C��ۍ������_�,^\���������s�W��\~k��𛗡߸m;�k�OCW�z_���}�*�dm좢R�?������'�%�nf2�x���0]WV{xoK��|	��K'���]:�Ή��'@�]R_���{���_���=�{�D!���%�W��:�1�'�6/mZ8π�[��)���_����oO}���o���/��w�ޘ/�_�<whN�cg��x�GG	��Љ�h}��C�{�?�H}����܅�?�:���+/����3�o|���d�_�����7o��꭮�Y��U��}G��Ҡ��{��_J��o^K��jj���'���+�Y;A۶�6^�m�c�;f�t�9i[�Ebh6G�m+��e�ysr(�Eڄ�H�s���/��k�2�����_~�7��߾r�����*�w*��*���խ�D�;/���R�O/�_����/����g��ҏ��,��3�=����;� �#�9�T����C� .Q�-ɠ>FJ�����"<�vL�FIZ���e��f�
$����"���]�r�zҒJ��]��,�<5�󁶮�UFO�<���75���@�9��� PY��h-�i���ZM*j)�o��qE݁(.v����q�)-D����6�2U��T�RӒ��ĳqYז�*&�>M���r��h��>2T�!R����bUC�)Tb[���f��[K�%R���(%�>��������ʠ:��-��tg"*!yj�>k������ [T�ñ2�c���@W+m�ΏNvcwPT�s!F|=�`Q��u�@sd��3��x4��U�z�D�F���JE�K��fb���R�Ω�Z���e} Q��~�c�e9J�ӝ��+"Y�@�d)0@*fD��nЕ<����I"�"�x%���j�5[��vgz!��0���>��nϯ�%�n���dŠԂB�Wk��-Ɣ�
��Y�)�P�J�*3~9 Y�Dw��ǸB��@�fk�cE=#���>�+RAHUf)m��>#6���G�(+�*YXKU�T�g$�]���5#�q�����[�48�a�O��W}6^��,�*�l��+fЍ�VC_�)W1��"��a�m�^Q�F*�
��Vj�ַ&t�j�~%�̣
��G��Da��a�$?�Ůe�}��*,��PV��9�h_�)M�J��ή��$#e
H�#�R'gke�'-���ȭzFf(��Lx�$�9����$�K�d��	N�����Ϙ��.Y�.�)��ؼPnɌ�h��F�`5�f��s�:�Lҋ𔳠�"�d�=�͝�rfw�A��E�Zi�A�_T$���'�x�e�!1�y ��*��l��\˨�=h�ȣ՞��%}�"z'��f^��EV����2����,٬��jT�n�l	^�Z�EX1���5�/��zDQ$$(�~���">A{Wf)�s�!�sL&�͜�8l�AA�H2����@ͱ���ȊY�NS����Se�5��#�@j�q�SC�R�;�;#��b���﫯?a�6����.ř>,ב��B��g��S��(�T�A�Eѥzz/�.��������dV��>XTՖ��-�e�L�9D/Aym*��	?�1�~���1���5�wEو9��+�1�����r�TG6Z��2��T��⑑գ�9�畁�3Hl�Zb�&"׋��(B�L��XDg3�XfZU,�GUC���;q�T�Bc�Ũ���Po�PQ����Z��b;3��	B[6��a�k�kՔ%Mwp®�*�aV=�1�d����&l��Ȧ�^�$q��$�K�8%�xW�h�XHdJZ�)Z�Kp�UQ"�B��~����$�`\�
���fO�����,1rb�\��@'Ɯ�g�m��o�y^���Wz�1�~��Q6K�\�4Y����Y���BvY���,R�'�p��Z3~��gf��i�q�P���/N�o\у�֕�)�����?����������1���@����'��ع�ڎC�z�N�|��ur�)�����'����_��6�_����׶��7���)㽆aŲ�u�xF��q@e!��@���y��3D6��;��~����	�Ie!�/����-D$�[��n1�z~�:~6lTG
"��r$�Ю�Q�^,��#S���&�w
jYPVoH�Hy�;ū�V'�C�c�Qh�i��>R,�|D�dj�y��w�*V�����xg�G�� ��C�� "7���k���k�Q��]�hF���-��ܞ�lxm���9h��e"�sz9h(�6�xf4�HY��-�٩��7�B9留D�އ�*�чT�.ޕ��T��暤�O'hέ����?N�Z����L�@���0��A�v�є�L�5ZF������k�YV3�pX���S��=Dg��-�#ʣ��h-�|F����n�a6rwW�T��I��\�%3H*���d4�8r��$.-�D�X�����t���hm5P�UT�l��C!G�sզgQe�-�o*}P����A��g�g6[�ӛ���A߳��S{��{Gc9}㱎��ô��(����"m�������o�\k�7o�z����_�/�TS��nw��MBr����ᴢx�XRr��������)n=%����Zv�xr�*��
o�wQz7���*��ЄݡmP�ȗLQ�r��h�@M�����r���*�̠㙻 ��쎦$�~�4�BZ��I8�dpQ�e��e�gb�\qr��ܰ|�^�=|�-E�V� �ŭ%��� %r�cS��4b~���)*q�����H�lP���a���Y5�'�Z�	�,�h���[r%��~����f�^����-22�)j�ݮ"�F`Czv�4�1J`�T�
^qy��6�
�e)3�2�m��b�U;lZ�,*�~%��D��}����LI⇓a�6�x\�FɫZBt�9t'��{�K�v�x���gٻg���wx �+�<�Z�rJ�&`k��ĀI���=x� �̒��Y���F����AK�ڝ.�"=W8��>([�R�i�@���Z�$d{�w�p����ͥ��ʃ�Mh��Mg!4gm!�#b'S��n��eQ=7�߉:
����H���2��.�#�wXo�Y��7Z9�W�Xp+=C�mh٪w��UW�-���2n5*�q ���8��Q�������=��b��w�.�9.�9.�9�߮s\D�>x��V��E�.V/VϿz���Bp1e�����mM[QG:�&�	�g!��j܁{�q� ��Q8�;
g�Q��="�a�Q��̳�2y�Qe���4aW�NX��IM�N��3c].4��j�+N���xX4�,�ke���B��%$���)���	\��	�2���.���H
|�0tt$=�@�N�]��~f��j�z�@;�7�H����FY������z�v"]b{>�h�0?A)��-������8��rdZ�嬩u1��+��1IP+A�|�!�#�r%�͈�X���D�{���ĶQ��O�]��w��O�O�F�vo:���&�8z�{�#�?}|є��1��O9�#������9��0�F�b����'�ǣ��oSt�P��ڊ�t�g�{��W_�&�ܫ�>���S+���n�t��$�Q��c��	�q*x��h~n��&ޡ9���Ng#Ӽ}l�K��{�u����;����NO�}7H��Nc�'_��-���sbnnP&㩽�=Nfo�����-���㘒��>�XHEH�Kv!sjx�&h�!���.�`��Q0
F  m2�A  