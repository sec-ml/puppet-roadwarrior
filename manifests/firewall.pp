# Configure firewall rules (using puppetlabs/firewall module) to permit ingress
# VPN connections and to also allow IP forwarding using (thias/sysctl).

class roadwarrior::firewall (
  $manage_firewall_v4 = $::roadwarrior::manage_firewall_v4,
  $manage_firewall_v6 = $::roadwarrior::manage_firewall_v6,
) {

  # IPv4
  if ($manage_firewall_v4) {

    # Enable packet fowarding
    if (!defined(Sysctl['net.ipv4.ip_forward'])) {
      sysctl { 'net.ipv4.ip_forward':
        value => '1',
      }
    }

    # Standard IPSec port
    firewall { '100 V4 Permit StrongSwan 500':
      protocol => 'iptables',
      proto    => 'udp',
      dport    => '500',
      jump     => 'accept',
    }

    # NAT-friendly IPSec port
    firewall { '100 V4 Permit StrongSwan 4500':
      protocol => 'iptables',
      proto    => 'udp',
      dport    => '4500',
      jump     => 'accept',
    }
  }


  # IPv6
  if ($manage_firewall_v6) {
    
    # Enable packet fowarding
    if (!defined(Sysctl['net.ipv4.ip_forward'])) {
      sysctl { 'net.ipv6.conf.all.forwarding':
        value => '1',
      }
    }

    # Standard IPSec port
    firewall { '100 V6 Permit StrongSwan 500':
      protocol => 'ip6tables',
      proto    => 'udp',
      dport    => '500',
      jump     => 'accept',
    }

    # NAT-friendly IPSec port
    firewall { '100 V6 Permit StrongSwan 4500':
      protocol => 'ip6tables',
      proto    => 'udp',
      dport    => '4500',
      jump     => 'accept',
    }
  }


}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
